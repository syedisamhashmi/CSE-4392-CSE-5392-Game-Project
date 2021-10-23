extends "res://entities/enemies/enemy_base/enemy_base.gd"

#region Animations
const DAMAGE = "damage"
const DEATH = "death"
const IDLE = "idle" 
const ROLLING = "rolling"
const ROLLING_HIT = "rolling_hit"  
const ROLLING_STOP = "rolling_stop"  
const START_ROLL = "start_roll"  
const WALK = "walk" # - Pantera
#endregion

#region Attributes
var maxHealth = 50
var health = 50
var HEALTH_HANDICAP = 5
var ROLL_ATTACK_DAMAGE = 1
var ROLL_ATTACK_DAMAGE_HANDICAP = 2

var ROLLING_DISTANCE = 300 
var ROLLING_DISTANCE_HANDICAP = 50

var MOVEMENT_SPEED = 10
var MOVEMENT_SPEED_HANDICAP = 5

var ROLL_TIMEOUT = 6000
var rollStart = 0

var damageStart = 0
var DAMAGE_TIMEOUT = 2000
var DAMAGE_TIMEOUT_HANDICAP = 400
var DIFFICULTY_HANDICAP = 1400
#endregion

var rng = RandomNumberGenerator.new()

var difficulty = PlayerDefaults.DEFAULT_DIFFICULTY
func _ready() -> void:
    rng.randomize()
    difficulty = PlayerData.savedGame.difficulty
    health += (HEALTH_HANDICAP * difficulty)
    maxHealth += (HEALTH_HANDICAP * difficulty)
    MOVEMENT_SPEED += MOVEMENT_SPEED_HANDICAP * (difficulty - 1)
    $Image.set_speed_scale(1 + (.2 * difficulty))
    ROLL_ATTACK_DAMAGE += ROLL_ATTACK_DAMAGE_HANDICAP * (difficulty - 1) 
    ROLLING_DISTANCE += ROLLING_DISTANCE_HANDICAP * difficulty
    ROLL_TIMEOUT -= DIFFICULTY_HANDICAP * difficulty
    DAMAGE_TIMEOUT -= DAMAGE_TIMEOUT_HANDICAP * difficulty

func _physics_process(delta: float) -> void:
    ._physics_process(delta)
    if (
        $Image.get_animation() != ROLLING_STOP and
        $Image.get_animation() != ROLLING_HIT
    ):
        handleAnimationState()

func player_location_changed(_position: Vector2):
    if( $Image.get_animation() == DAMAGE or 
        $Image.get_animation() == ROLLING_STOP or
        $Image.get_animation() == ROLLING_HIT
    ):
        return
    var dist = self.position.distance_to(_position)
    var dir = self.position.direction_to(_position)
    
    # If within walking distance
    if (abs(dist) < ROLLING_DISTANCE 
    # and not trying inside the player on the left side
        and ((dir.x > 0 and abs(dist) > 32) 
    # or the right side, numbers are different due to the sprite and bounding boxes
            or (dir.x < 0 and abs(dist) > 70)
        )
        and OS.get_system_time_msecs() - damageStart > DAMAGE_TIMEOUT
    ):
        if ($Image.get_animation() != ROLLING and
            $Image.get_animation() != ROLLING_STOP and
            $Image.get_animation() != ROLLING_HIT and
            OS.get_system_time_msecs() - rollStart > ROLL_TIMEOUT
        ):
            $Image.set_animation(START_ROLL)
            rollStart = OS.get_system_time_msecs()
        elif ($Image.get_animation() == ROLLING_HIT or
            $Image.get_animation() == ROLLING_STOP
        ):
            return
        else:
            if ($Image.get_animation() == ROLLING):
                $Roll/RollBox.disabled = false
                if dir.x <= 0:
                    velocity.x -= MOVEMENT_SPEED
                else:
                    velocity.x += MOVEMENT_SPEED
        handle_enemy_direction(dir.x )
        handleAnimationState()
    
func handle_enemy_direction(dir: float) -> void:
    var before = $Image.flip_h
    $Image.flip_h = dir < 0
    if before != $Image.flip_h:
        if $Image.get_animation() == ROLLING:
            $Image.set_animation(ROLLING_STOP)

func _on_Image_animation_finished() -> void:
    var anim = $Image.get_animation()
    if (anim == ROLLING_STOP or 
        anim == ROLLING_HIT
    ):
          $Image.set_animation(IDLE)
    if anim == START_ROLL:
        $Image.set_animation(ROLLING)
    if anim == DAMAGE:
        handleAnimationState()

func damage(_damage: float, knockback, isPunch : bool  = false, punchNum = 0):
    #? Call parent function to ensure it was hit
    var hit = .damage(_damage, knockback * 2, isPunch, punchNum)
    # If parent deemed enemy not hit, return.
    if !hit:
        return
    $Roll/RollBox.disabled = true
    damageStart = OS.get_system_time_msecs()
    var calculatedDamage = abs(_damage) / difficulty
    health -= calculatedDamage
    # Signal out we are dealing damage to the player for stat-tracking.
    Signals.emit_signal("player_damage_dealt", calculatedDamage)
    $Image.set_animation(DAMAGE)
    if (health <= 0):
        queue_free()

func handleAnimationState() -> void:
    var anim = $Image.get_animation()
    if (anim == START_ROLL or
        anim == ROLLING_HIT
    ):
        return
        
    if abs(velocity.x) <= 5:
        if anim == DAMAGE and OS.get_system_time_msecs() - damageStart > DAMAGE_TIMEOUT :
          $Image.set_animation(IDLE)
        if anim == ROLLING:
          $Image.set_animation(ROLLING_STOP)
    return

func _on_Roll_body_entered(body: Node) -> void:
    if $Image.get_animation() != ROLLING:
        return
    
    $Roll/RollBox.disabled = true
    if body.has_method("damage"):
        body.damage(ROLL_ATTACK_DAMAGE * velocity.sign().x, 1.5)
        $Image.set_animation(ROLLING_HIT)
        velocity.x -= 100
        velocity.y -= 200
