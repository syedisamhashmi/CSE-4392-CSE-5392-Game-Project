extends "res://entities/enemies/enemy_base/enemy_base.gd"

#region Animations
const ATTACK = "idle"
const DAMAGE = "idle"
const IDLE = "idle" 
const WALK = "idle" # - Pantera
#endregion

#region Attributes
var maxHealth = 150
var HEALTH_HANDICAP = 25

var WALKING_DISTANCE = 0 
var WALKING_DISTANCE_HANDICAP = 0

var MOVEMENT_SPEED = 0
var MOVEMENT_SPEED_HANDICAP = 0

var ATTACK_DAMAGE = 0
var ATTACK_DAMAGE_HANDICAP = 0
var ATTACK_TIMEOUT = 2000
var attackStart = 0

var damageStart = 0
var DAMAGE_TIMEOUT = 2000
var DAMAGE_TIMEOUT_HANDICAP = 0
var DIFFICULTY_HANDICAP = 0
#endregion

var rng = RandomNumberGenerator.new()

var difficulty = PlayerDefaults.DEFAULT_DIFFICULTY
func _ready() -> void:
    difficulty = PlayerData.savedGame.difficulty
    rng.randomize()
    if health == 9999:
        health = baseHealth
        maxHealth = baseHealth
        type = EntityTypeEnums.ENEMY_TYPE.NPC
        health += (HEALTH_HANDICAP * difficulty)
        maxHealth += (HEALTH_HANDICAP * difficulty)
    MOVEMENT_SPEED += MOVEMENT_SPEED_HANDICAP * (difficulty - 1)
    $Image.set_speed_scale(1 + (.2 * difficulty))
    WALKING_DISTANCE += WALKING_DISTANCE_HANDICAP * difficulty
    ATTACK_TIMEOUT -= DIFFICULTY_HANDICAP * difficulty
    DAMAGE_TIMEOUT -= DAMAGE_TIMEOUT_HANDICAP * difficulty
    ATTACK_DAMAGE += ATTACK_DAMAGE_HANDICAP * difficulty

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
        $Image.get_animation() != DAMAGE
    ):
        handleAnimationState()
    updateEnemyDetails(id)
var lastDir = null
func player_location_changed(_position: Vector2):
    if !Globals.inGame:
        return
    if( 
        $Image.get_animation() == DEATH or 
        $Image.get_animation() == DAMAGE
    ):
        return
    var dist = self.position.distance_to(_position)
    var dir = self.position.direction_to(_position)
    
    
    # If within walking distance
    if abs(dist) < WALKING_DISTANCE:
        if (
        abs(dist) < 100 and
        OS.get_system_time_msecs() - attackStart > ATTACK_TIMEOUT    
        ):
            handle_enemy_direction(dir.x)
            $Image.set_animation(ATTACK)
            attackStart = OS.get_system_time_msecs()
            lastDir = dir.sign().x
            return
        if ($Image.get_animation() != WALK and
            $Image.get_animation() != ATTACK and
            $Image.get_animation() != DAMAGE
        ):
            $Image.set_animation(WALK)
        if ($Image.get_animation() == WALK):
            var anim = $Image.get_animation()
            if (anim != ATTACK and anim != DAMAGE):
                if dir.x <= 0:
                    self.velocity.x -= MOVEMENT_SPEED
                else:
                    self.velocity.x += MOVEMENT_SPEED
        handle_enemy_direction(dir.x)
        handleAnimationState()
    
func handle_enemy_direction(dir: float) -> void:
    if !Globals.inGame:
        return
    $Image.flip_h = dir < 0

func _on_Image_animation_finished() -> void:
    if !Globals.inGame:
        return
    var anim = $Image.get_animation()
    if anim == ATTACK or anim == DAMAGE:
        $Image.set_animation(IDLE)

func damage(_damage: float, knockback, isPunch : bool  = false, punchNum = -1):
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
    if (
        anim == DEATH or
        anim == IDLE
    ):
        return
        
    if abs(velocity.x) <= 5:
        if anim == DAMAGE and OS.get_system_time_msecs() - damageStart > DAMAGE_TIMEOUT :
          $Image.set_animation(IDLE)
        
        if anim == WALK :
          $Image.set_animation(IDLE)
    return

func _on_Image_frame_changed() -> void:
    if (
        $Image.get_animation() == ATTACK and 
        $Image.get_frame() >= 4 and $Image.get_frame() <= 6
    ):
        $RightAttack/Coll.set_deferred("disabled", lastDir < 0)
        $LeftAttack/Coll.set_deferred("disabled", lastDir > 0)
    else:
        $RightAttack/Coll.set_deferred("disabled", true)
        $LeftAttack/Coll.set_deferred("disabled", true)


func _on_Attack_body_entered(body: Node) -> void:
    if !Globals.inGame:
        return
    if body.has_method("damage"):
      body.damage(ATTACK_DAMAGE * (-1 if $Image.flip_h else 1), 2)
