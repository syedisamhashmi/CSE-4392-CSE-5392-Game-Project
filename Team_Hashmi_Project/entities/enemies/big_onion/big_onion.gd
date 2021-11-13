extends "res://entities/enemies/enemy_base/enemy_base.gd"

var POISON = preload("res://entities/enemies/big_onion/poison.tscn")

#region Animations
const ATTACK = "attack"
const DAMAGE = "damage"
const IDLE = "idle"
const WALK = "walk" # - Pantera
#endregion

#region Attributes
var maxHealth = 150
var HEALTH_HANDICAP = 5

var WALKING_DISTANCE = 300 
var WALKING_DISTANCE_HANDICAP = 50

var MOVEMENT_SPEED = 6
var MOVEMENT_SPEED_HANDICAP = 2

var ATTACK_TIMEOUT = 2000
var attackStart = 0

var damageStart = 0
var DAMAGE_TIMEOUT = 2000
var DAMAGE_TIMEOUT_HANDICAP = 400
var DIFFICULTY_HANDICAP = 300
#endregion

var rng = RandomNumberGenerator.new()

var difficulty = PlayerDefaults.DEFAULT_DIFFICULTY
var dir = Vector2.ZERO

func _ready() -> void:
    rng.randomize()
    difficulty = PlayerData.savedGame.difficulty
    if health == 9999:
        health = baseHealth
        maxHealth = baseHealth
        type = EntityTypeEnums.ENEMY_TYPE.BIG_ONION
        health += (HEALTH_HANDICAP * difficulty)
        maxHealth += (HEALTH_HANDICAP * difficulty)
    MOVEMENT_SPEED += MOVEMENT_SPEED_HANDICAP * (difficulty - 1)
    $Image.set_speed_scale(1 + (.2 * difficulty))
    $Image.get_sprite_frames().set_animation_speed(DAMAGE, 5 + difficulty)
    $Image.get_sprite_frames().set_animation_speed(ATTACK, 5 + (2 * difficulty))
    WALKING_DISTANCE += WALKING_DISTANCE_HANDICAP * difficulty
    ATTACK_TIMEOUT -= DIFFICULTY_HANDICAP * difficulty
    DAMAGE_TIMEOUT -= DAMAGE_TIMEOUT_HANDICAP * difficulty

func _physics_process(delta: float) -> void:
    if !Globals.inGame:
        $Image.playing = false
        return
    else:
        $Image.playing = true
    checkAlive()
    if $Image.get_animation() == DEATH:
        return
    ._physics_process(delta)
    if (
        $Image.get_animation() != ATTACK
    ):
        handleAnimationState()
    updateEnemyDetails(id)
func player_location_changed(_position: Vector2):
    if !Globals.inGame:
        return
    if( 
        $Image.get_animation() == DEATH or 
        $Image.get_animation() == DAMAGE or 
        $Image.get_animation() == ATTACK 
    ):
        return
    var dist = self.position.distance_to(_position)
    dir = self.position.direction_to(_position)
    
    # If within walking distance
    if (abs(dist) < WALKING_DISTANCE 
    # and not trying inside the player on the left side
        and ((dir.x > 0 and abs(dist) > 32) 
    # or the right side, numbers are different due to the sprite and bounding boxes
            or (dir.x < 0 and abs(dist) > 70)
        )
        and OS.get_system_time_msecs() - damageStart > DAMAGE_TIMEOUT
    ):
        if (
            $Image.get_animation() != ATTACK and
            OS.get_system_time_msecs() - attackStart > ATTACK_TIMEOUT
        ):
            $Image.set_animation(ATTACK)
        else:
            if $Image.get_animation() == IDLE:
                $Image.set_animation(WALK)
            if ($Image.get_animation() == WALK):
                if dir.x <= 0:
                    velocity.x -= MOVEMENT_SPEED
                else:
                    velocity.x += MOVEMENT_SPEED
            handle_enemy_direction(dir.x)
            handleAnimationState()
    
func handle_enemy_direction(_dir: float) -> void:
    if !Globals.inGame:
        return
    $Image.flip_h = _dir < 0

func _on_Image_animation_finished() -> void:
    if !Globals.inGame:
        return
    var anim = $Image.get_animation()
    if anim == ATTACK:
        attackStart = OS.get_system_time_msecs()
        var poison = POISON.instance()
        var toShootDir = Vector2.UP
        toShootDir.x = dir.x
        poison.init(self.position, toShootDir)
        $OnionGas.add_child(poison)
        $Image.set_animation(IDLE)
    if anim == DAMAGE:
        handleAnimationState()

func damage(_damage: float, knockback, isPunch : bool  = false, punchNum = 0):
    if !Globals.inGame:
        return
    if ($Image.get_animation() == DEATH):
        return
    #? Call parent function to ensure it was hit
    var hit = .damage(_damage, knockback * 2, isPunch, punchNum)
    # If parent deemed enemy not hit, return.
    if !hit:
        return
    damageStart = OS.get_system_time_msecs()
    var calculatedDamage = abs(_damage)
    health -= calculatedDamage
    updateEnemyDetails(id)
    # Signal out we are dealing damage to the player for stat-tracking.
    Signals.emit_signal("player_damage_dealt", calculatedDamage)
    $Image.set_animation(DAMAGE)
    checkAlive()

func handleAnimationState() -> void:
    if !Globals.inGame:
        return
    var anim = $Image.get_animation()
            
    if abs(velocity.x) <= 5:
        if anim == DAMAGE and OS.get_system_time_msecs() - damageStart > DAMAGE_TIMEOUT :
            $Image.set_animation(IDLE)
        if anim == WALK:
            $Image.set_animation(IDLE)
    return
