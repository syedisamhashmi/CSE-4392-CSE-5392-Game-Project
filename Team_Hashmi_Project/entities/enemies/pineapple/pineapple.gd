extends "res://entities/enemies/enemy_base/enemy_base.gd"

var PROJECTILE = preload("res://entities/enemy-projectile/enemy-projectile.tscn")

#region AnimationNames
var IDLE = "Idle"
var WALK = "Walk"
var CHEST_BUMP = "Chest_Bump"
var TAKE_DAMAGE = "Take_Damage"
var JUMP_ATTACK = "Jump_Attack"
#endregion

var canChestBump = true
var startChestBump = OS.get_system_time_msecs()

var isJumping = false
var jumpVel = 0
var canJump = false
var startJump = OS.get_system_time_msecs()

var hitFloorStart = 0
var maxHealth = 100
var health = 100
var HEALTH_HANDICAP = 100

var CHEST_BUMP_DAMAGE = 5
var JUMP_ATTACK_DAMAGE = 15

var JUMPING_DISTANCE = 500
var JUMPING_DISTANCE_HANDICAP = 50
var WALKING_DISTANCE = 400 
var JUMP_HEIGHT = 750
var MOVEMENT_SPEED = 10

var JUMP_TIMEOUT = 5000
var CHEST_BUMP_TIMEOUT = 1500

var JUMP_ACCURACY_REDUCER = 21
var DIFFICULTY_HANDICAP = 300
var JUMP_ACCURACY_HANDICAP = 3
var rng = RandomNumberGenerator.new()

var THROW_COOLDOWN = 1500
var THROW_COOLDOWN_HANDICAP = 320
var throwStart = 0
var MAX_PROJECTILE = 1
var MAX_PROJECTILE_HANDICAP = 10

func _ready() -> void:
    rng.randomize()
    health += (HEALTH_HANDICAP * PlayerData.getSavedGame()[PlayerData.DIFFICULTY])
    maxHealth += (HEALTH_HANDICAP * PlayerData.getSavedGame()[PlayerData.DIFFICULTY])
    CHEST_BUMP_TIMEOUT -= (DIFFICULTY_HANDICAP * PlayerData.getSavedGame()[PlayerData.DIFFICULTY])
    JUMP_TIMEOUT -= (DIFFICULTY_HANDICAP * PlayerData.getSavedGame()[PlayerData.DIFFICULTY] * 2)
    JUMP_ACCURACY_REDUCER -= (JUMP_ACCURACY_HANDICAP * PlayerData.getSavedGame()[PlayerData.DIFFICULTY])
    JUMPING_DISTANCE += (JUMPING_DISTANCE_HANDICAP * PlayerData.getSavedGame()[PlayerData.DIFFICULTY])
    THROW_COOLDOWN -= (THROW_COOLDOWN_HANDICAP * PlayerData.getSavedGame()[PlayerData.DIFFICULTY])
    MAX_PROJECTILE += (MAX_PROJECTILE_HANDICAP * PlayerData.getSavedGame()[PlayerData.DIFFICULTY])

func _physics_process(delta: float) -> void:
    ._physics_process(delta)
    if ($LeftChestBox.get_overlapping_bodies().size() != 0 or
        $RightChestBox.get_overlapping_bodies().size() != 0):
        _on_ChestBox_body_entered(null)
    
    if isJumping:
        velocity.x += jumpVel
    
    if is_on_floor() :
        if (isJumping and OS.get_system_time_msecs() - startJump > 100 ):
            $JumpAttackBox/JumpAttackBoxCollision.disabled = false
            hitFloorStart = OS.get_system_time_msecs()
            $JumpAttackBox/JumpParticles.set_emitting(true)
        else:
            if (OS.get_system_time_msecs() - hitFloorStart > 100):
                $JumpAttackBox/JumpAttackBoxCollision.disabled = true
                $JumpAttackBox/JumpParticles.set_emitting(false)
        isJumping = false
        canJump = true

    if ($Image.get_animation() != CHEST_BUMP and
        $Image.get_animation() != TAKE_DAMAGE and
        !isJumping):
        handleAnimationState()
    
func player_location_changed(_position: Vector2):
    if($Image.get_animation() == TAKE_DAMAGE):
        return
    var dist = self.position.distance_to(_position)
    var dir = self.position.direction_to(_position)
    # If they are further than walking distance units
    if (
        canJump and 
        (OS.get_system_time_msecs() - startJump) >= JUMP_TIMEOUT and
        abs(dist) < JUMPING_DISTANCE and 
        abs(dist) > WALKING_DISTANCE and 
        !isJumping
    ):
        if (health < maxHealth/2):
            if (OS.get_system_time_msecs() - THROW_COOLDOWN > throwStart
            and $Projectiles.get_child_count() < MAX_PROJECTILE):
                throwStart = OS.get_system_time_msecs()
                $Image.set_animation(CHEST_BUMP)
                var projectile_instance = PROJECTILE.instance()
                dir.x *= dist / rng.randf_range(
                    10 * PlayerData.getSavedGame()[PlayerData.DIFFICULTY], 
                    100)
                dir.y = -5
                projectile_instance.init(
                    # Add projectile halfway up the player so that it
                    # spawns in a good place.
                    Vector2(self.position.x + 20, self.position.y - 30), 
                    dir)
                $Projectiles.add_child(projectile_instance) 
        else: 
            startJump = OS.get_system_time_msecs()
            isJumping = true
            velocity.y -= JUMP_HEIGHT
            $Image.set_animation(JUMP_ATTACK)
            if dir.x <= 0:
                jumpVel = -(dist/JUMP_ACCURACY_REDUCER)
            else:
                jumpVel = dist / JUMP_ACCURACY_REDUCER

    # If within walking distance
    elif (abs(dist) < WALKING_DISTANCE 
    # and not trying inside the player on the left side
        and ((dir.x > 0 and abs(dist) > 100) 
    # or the right side, numbers are different due to the sprite and bounding boxes
            or (dir.x < 0 and abs(dist) > 70)
        )
    ):
        if dir.x <= 0:
            velocity.x -= MOVEMENT_SPEED
        else:
            velocity.x += MOVEMENT_SPEED
        handle_enemy_direction(dir.x )
    
    
func handle_enemy_direction(dir: float) -> void:
    $Image.flip_h = dir > 0
    $LeftChestBox/LeftChestBoxCollision.set_disabled(dir > 0)
    $RightChestBox/RightChestBoxCollision.set_disabled(dir < 0)

func _on_ChestBox_body_entered(_body: Node) -> void:
    var bodies = $LeftChestBox.get_overlapping_bodies() + $RightChestBox.get_overlapping_bodies()
    if (canChestBump and 
        (OS.get_system_time_msecs() - startChestBump) >= CHEST_BUMP_TIMEOUT):
        for body in bodies:
            canChestBump = false
            startChestBump = OS.get_system_time_msecs()
            $Image.set_frame(0)
            $Image.set_animation(CHEST_BUMP)
            if body.has_method("damage"):
                body.damage(CHEST_BUMP_DAMAGE, 1)

func _on_Image_animation_finished() -> void:
    if ($Image.get_animation() == JUMP_ATTACK):
        handleAnimationState()
    if (OS.get_system_time_msecs() - startChestBump >= CHEST_BUMP_TIMEOUT):
        canChestBump = true
    if ($Image.get_animation() == CHEST_BUMP or
        $Image.get_animation() == TAKE_DAMAGE):
        canChestBump = true
        handleAnimationState()


func damage(damage: float, knockback, isPunch : bool  = false):
    .damage(damage, knockback * 2, isPunch)
    health -= abs(damage) / PlayerData.getSavedGame()[PlayerData.DIFFICULTY]
    $Image.set_animation(TAKE_DAMAGE)
    canChestBump = false
    if (health <= 0):
        queue_free()

func handleAnimationState() -> void:
    
    $LeftChestBox/LeftChestBoxCollision.set_disabled(isJumping)
    $RightChestBox/RightChestBoxCollision.set_disabled(isJumping)
    if abs(velocity.x) <= 5:
        if $Image.get_animation() != IDLE:
          $Image.set_animation(IDLE)
    else:
        if ($Image.get_animation() != WALK):
            $Image.set_animation(WALK)
    return


func _on_JumpAttackBox_body_entered(body: Node) -> void:
    if (OS.get_system_time_msecs() - hitFloorStart > 100):
        $JumpAttackBox/JumpAttackBoxCollision.disabled = true
        $JumpAttackBox/JumpParticles.set_emitting(false)
        return
    if body.has_method("damage"):
      body.damage(JUMP_ATTACK_DAMAGE, 2)
