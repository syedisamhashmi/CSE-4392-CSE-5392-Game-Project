extends "res://entities/enemies/enemy_base/enemy_base.gd"

var canChestBump = true
var startChestBump = OS.get_system_time_msecs()

var isJumping = false
var jumpVel = 0
var canJump = false
var startJump = OS.get_system_time_msecs()

var hitFloorStart = 0


var JUMPING_DISTANCE = 500
var WALKING_DISTANCE = 400 
var JUMP_HEIGHT = 750
var MOVEMENT_SPEED = 10
var JUMP_TIMEOUT = 5000
var CHEST_BUMP_TIMEOUT = 1500

func _ready() -> void:
    pass

func _physics_process(delta: float) -> void:
    ._physics_process(delta)
    if ($LeftChestBox.get_overlapping_bodies().size() != 0 or
        $RightChestBox.get_overlapping_bodies().size() != 0):
        _on_ChestBox_body_entered(null)
    
    if isJumping:
        velocity.x += jumpVel
    
    if is_on_floor() :
        if (isJumping):
            $JumpAttackBox/JumpAttackBoxCollision.disabled = false
            hitFloorStart = OS.get_system_time_msecs()
            $JumpAttackBox/JumpParticles.set_emitting(true)
        else:
            if (OS.get_system_time_msecs() - hitFloorStart > 100):
                $JumpAttackBox/JumpAttackBoxCollision.disabled = true
                $JumpAttackBox/JumpParticles.set_emitting(false)
        isJumping = false
        canJump = true

    if ($Image.get_animation() != "Chest_Bump" and
        $Image.get_animation() != "Take_Damage" and
        !isJumping):
        handleAnimationState()
    
func player_location_changed(_position: Vector2):
    if($Image.get_animation() == "Take_Damage"):
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
        startJump = OS.get_system_time_msecs()
        isJumping = true 
        $Image.set_animation("Jump_Attack")
        if dir.x <= 0:   
            jumpVel = -(dist/15)
        else:
            jumpVel = dist / 15
        velocity.y -= JUMP_HEIGHT

    if (abs(dist) < WALKING_DISTANCE 
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
            $Image.set_animation("Chest_Bump")
            if body.has_method("damage"):
                body.damage(25 * (-1 if !$Image.flip_h else 1), .5)

func _on_Image_animation_finished() -> void:
    if ($Image.get_animation() == "Jump_Attack"):
        handleAnimationState()
    if (OS.get_system_time_msecs() - startChestBump >= CHEST_BUMP_TIMEOUT):
        canChestBump = true
    if ($Image.get_animation() == "Chest_Bump" or
        $Image.get_animation() == "Take_Damage"):
        canChestBump = true
        handleAnimationState()


func damage(knockback, isPunch : bool  = false):
    .damage(knockback, isPunch)
    $Image.set_animation("Take_Damage")
    canChestBump = false
    

func _on_ChestBox_body_exited(_body: Node) -> void:
#    playerInside = null
    pass

func handleAnimationState() -> void:
    if abs(velocity.x) <= 5:
        if $Image.get_animation() != "Idle":
          $Image.set_animation("Idle")
    else:
        if ($Image.get_animation() != "Walk"):
            $Image.set_animation("Walk")
    return


func _on_JumpAttackBox_body_entered(body: Node) -> void:
    print("Player hit with jump attack")
    if (OS.get_system_time_msecs() - hitFloorStart > 100):
        $JumpAttackBox/JumpAttackBoxCollision.disabled = true
        $JumpAttackBox/JumpParticles.set_emitting(false)
        return
    if body.has_method("damage"):
      body.damage(50 * 1 if !$Image.flip_h else -1, 1)
