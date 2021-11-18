extends "res://entities/enemies/enemy_base/enemy_base.gd"

#region Animations
const DAMAGE = "damage"
const IDLE = "idle" 
const SPIN = "spin"
const SPIN_START = "spin_start"  
const SPIN_STOP = "spin_stop"  
const WALK = "walk" # - Pantera
#endregion

#region Attributes
var maxHealth = 50
var HEALTH_HANDICAP = 5
var SPIN_ATTACK_DAMAGE = 10
var SPIN_ATTACK_DAMAGE_HANDICAP = 4

var SPIN_DISTANCE = 300 
var SPIN_DISTANCE_HANDICAP = 50

var MOVEMENT_SPEED = 10
var MOVEMENT_SPEED_HANDICAP = 5

var SPIN_TIMEOUT = 6000
var spinStart = 0

var damageStart = 0
var DAMAGE_TIMEOUT = 2000
var DAMAGE_TIMEOUT_HANDICAP = 400
var DIFFICULTY_HANDICAP = 1400
#endregion

var rng = RandomNumberGenerator.new()

var difficulty = PlayerDefaults.DEFAULT_DIFFICULTY
func _ready() -> void:
    difficulty = PlayerData.savedGame.difficulty
    rng.randomize()
    if health == 9999:
        health = baseHealth
        maxHealth = baseHealth
        type = EntityTypeEnums.ENEMY_TYPE.RADDISH
        health += (HEALTH_HANDICAP * difficulty)
        maxHealth += (HEALTH_HANDICAP * difficulty)
    MOVEMENT_SPEED += MOVEMENT_SPEED_HANDICAP * (difficulty - 1)
    $Image.set_speed_scale(1 + (.2 * difficulty))
    SPIN_ATTACK_DAMAGE += SPIN_ATTACK_DAMAGE_HANDICAP * (difficulty - 1) 
    SPIN_DISTANCE += SPIN_DISTANCE_HANDICAP * difficulty
    SPIN_TIMEOUT -= DIFFICULTY_HANDICAP * difficulty
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
        $Image.get_animation() != SPIN_STOP
    ):
        handleAnimationState()
    updateEnemyDetails(id)

func player_location_changed(_position: Vector2):
    if !Globals.inGame:
        return
    if( 
        $Image.get_animation() == DEATH or 
        $Image.get_animation() == DAMAGE or 
        $Image.get_animation() == SPIN_STOP
    ):
        return
    var dist = self.position.distance_to(_position)
    var dir = self.position.direction_to(_position)
    
    # If within walking distance
    if (abs(dist) < SPIN_DISTANCE 
        and OS.get_system_time_msecs() - damageStart > DAMAGE_TIMEOUT
    ):
        if ($Image.get_animation() != SPIN and
            $Image.get_animation() != SPIN_STOP and
            OS.get_system_time_msecs() - spinStart > SPIN_TIMEOUT
        ):
            $Image.set_animation(SPIN_START)
            spinStart = OS.get_system_time_msecs()
        elif ($Image.get_animation() == SPIN_STOP):
            return
        else:
            var anim = $Image.get_animation()
            if (anim == SPIN or anim == SPIN_START):
                $spin/spinColl.set_deferred("disabled", false)
                if dir.x <= 0:
                    self.velocity.x -= MOVEMENT_SPEED
                else:
                    self.velocity.x += MOVEMENT_SPEED
        handle_enemy_direction(dir.x )
        handleAnimationState()
    
func handle_enemy_direction(dir: float) -> void:
    if !Globals.inGame:
        return
    var before = $Image.flip_h
    $Image.flip_h = dir < 0
    if before != $Image.flip_h:
        if $Image.get_animation() == SPIN:
            $Image.set_animation(SPIN_STOP)

func _on_Image_animation_finished() -> void:
    if !Globals.inGame:
        return
    var anim = $Image.get_animation()
    if (anim == SPIN_STOP
    ):
          $Image.set_animation(IDLE)
    if anim == SPIN_START:
        $Image.set_animation(SPIN)
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
    $spin/spinColl.set_deferred('disabled', true)
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
        anim == DEATH       or
        anim == SPIN_START
    ):
        return
        
    if abs(velocity.x) <= 5:
        if anim == DAMAGE and OS.get_system_time_msecs() - damageStart > DAMAGE_TIMEOUT :
          $Image.set_animation(IDLE)
        if anim == SPIN:
          $Image.set_animation(SPIN_STOP)
    return

func _on_spin_body_entered(body: Node) -> void:
    if !Globals.inGame:
        return
    if $Image.get_animation() != SPIN and $Image.get_animation() != SPIN_START:
        return
    
    $spin/spinColl.set_deferred("disabled", true)
    if body.has_method("damage"):
        body.damage(SPIN_ATTACK_DAMAGE * velocity.sign().x, 1.5)
        $Image.set_animation(SPIN_STOP)

