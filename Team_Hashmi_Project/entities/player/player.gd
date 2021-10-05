extends KinematicBody2D

#REGION PRELOAD
var PLAYER_PROJECTILE = preload("res://entities/player_projectile/player_projectile.tscn")
#ENDREGION

# Half of the players width, determines where the projectile is spawned horizontally
var horizontalLaunchArea = 24 
var fullWidthOfPlayer = 32 
# Half of the players height, determines where the projectile is spawned vertically
var verticalLaunchArea = 40
var fullHeightOfPlayer = 64 

var rightFace = Rect2(Vector2(0,0), Vector2(fullWidthOfPlayer, fullHeightOfPlayer))
var leftFace = Rect2(Vector2(fullWidthOfPlayer, 0), Vector2(fullWidthOfPlayer, fullHeightOfPlayer))

var SPEED_DEADZONE = 3

# These are very sensitive, change with care
var projectile_speed: Vector2 = Vector2(4, -4)

# some of these variables could be exported for easy modification
# in the editor's user interface
var acceleration: Vector2 = Vector2(600, 400)
var topSpeed: Vector2 = Vector2(400.0, 500.0)
var airControlModifier: Vector2 = Vector2(0.95, 0.0)

var friction: float = 0.90

var velocity: Vector2 = Vector2.ZERO
var gravity: float = 900.0

# Player can only be facing one of these two directions.
enum PlayerDirection {
 LEFT  = -1,
 RIGHT =  1,   
}

# Start off saying player was last facing to the right.
var lastDir = PlayerDirection.RIGHT 

func _physics_process(delta: float) -> void:
<<<<<<< Updated upstream
    var leftToRightRatio: float =  Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
    # used to allow shorter jumps if jump button is released quickly
    var isJumpInterrupted: bool = Input.is_action_just_released("jump") and velocity.y < 0.0
    
    # want to feel instant and responsive, so don't bother with acceleration
    # i.e. just set their velocity to the jump acceleration.
    if Input.is_action_just_pressed("jump") and is_on_floor():
        # Increase player data for jump count
        PlayerData.setJumpCount(PlayerData.getJumpCount() + 1)
        velocity.y = -acceleration.y
      
    # checks if jump is interrupted, if so, stop player from moving up
    if isJumpInterrupted :
      velocity.y = 0.0
    
    # increases velocity on the x axis every frame
    velocity.x += (acceleration.x * leftToRightRatio * delta) 

    # If player was last seen going to the right, set that.
    if (velocity.x > 0):
        lastDir = PlayerDirection.RIGHT
        $BananaImage.region_rect = rightFace
    # If player was last seen going to the left, set that.
    elif (velocity.x < 0):
        lastDir = PlayerDirection.LEFT
        $BananaImage.region_rect = leftFace

    # If player is in the air, make it slower for them to move horizontally.
    if (velocity.y != 0):
        velocity.x *= airControlModifier.x
        
    
    velocity.y += gravity * delta
=======
	var leftToRightRatio: float =  Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	# used to allow shorter jumps if jump button is released quickly
	var isJumpInterrupted: bool = Input.is_action_just_released("jump") and velocity.y < 0.0
	
	# want to feel instant and responsive, so don't bother with acceleration
	# i.e. just set their velocity to the jump acceleration.
	if Input.is_action_just_pressed("jump") and is_on_floor():
	  velocity.y = -acceleration.y
	  
	# checks if jump is interrupted, if so, stop player from moving up
	if isJumpInterrupted :
	  velocity.y = 0.0
	
	# increases velocity on the x axis every frame
	velocity.x += (acceleration.x * leftToRightRatio * delta) 
	
	# If player is in the air, make it slower for them to move horizontally.
	if (velocity.y != 0):
		velocity.x *= airControlModifier.x
		
	
	velocity.y += gravity * delta
>>>>>>> Stashed changes
  
	# clamp velocity
	# Nice call Edward! - Isam
	velocity.x = clamp(velocity.x, -topSpeed.x, topSpeed.x)

<<<<<<< Updated upstream
    # Only apply friction if they aren't trying to move
    if ((!Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"))
    # or if they hit both buttons, I know it sounds weird, but it feels right?
    or (Input.is_action_pressed("move_left") and Input.is_action_pressed("move_right"))
    ):
        velocity.x *= friction
    
    # removes jitter when player is slowing down
    if abs(velocity.x) < SPEED_DEADZONE:
      velocity.x = 0
    
    # Godot's built in function to determine final velocity
    velocity = move_and_slide(velocity, Vector2.UP)
    
=======
	# Only apply friction if they aren't trying to move
	if ((!Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"))
	# or if they hit both buttons, I know it sounds weird, but it feels right?
	or (Input.is_action_pressed("move_left") and Input.is_action_pressed("move_right"))
	):
		velocity.x *= friction
	
	# removes jitter when player is slowing down
	# This used to be 10, 3 felt better and works with the numbers.
	if abs(velocity.x) < 3:
	  velocity.x = 0
	
	# Godot's built in function to determine final velocity
	velocity = move_and_slide(velocity, Vector2.UP)
	
>>>>>>> Stashed changes
func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("fire_projectile")):
		spawnPlayerProjectile()
		pass

func spawnPlayerProjectile() -> void:
<<<<<<< Updated upstream
    # Increase player data for shots fired
    PlayerData.setShotsFired(PlayerData.getShotsFired() + 1)

    var projectile_instance = PLAYER_PROJECTILE.instance()
    
    var projectile_speed_to_use = projectile_speed
     
    # Add some of the players velocity to the projectile
    # horizontally so that it doesn't exactly go behind the player
    # NOT vertically, feels off to do that.
    # Set direction horizontally by using the last direction the player was facing.
    # When you stop moving, you don't just turn back to the right side.
    projectile_speed_to_use.x = ((projectile_speed_to_use.x * lastDir) + (velocity.x / 60))
    projectile_instance.init(
        # Add projectile halfway up the player so that it
        # spawns in a good place.
        Vector2(self.position.x + horizontalLaunchArea, self.position.y - verticalLaunchArea), 
        projectile_speed_to_use)
    $Projectiles.add_child(projectile_instance)
=======
	var projectile_instance = PLAYER_PROJECTILE.instance()
	
	var projectile_speed_to_use = projectile_speed
	if velocity.x < 0:
		projectile_speed_to_use.x *= -1
	 
	# Add some of the players velocity to the projectile
	# horizontally so that it doesn't exactly go behind the player
	# NOT vertically, feels off to do that.
	projectile_speed_to_use.x = (projectile_speed_to_use.x + (velocity.x / 60))
	projectile_instance.init(
		# Add projectile halfway up the player so that it
		# spawns in a good place.
		Vector2(self.position.x + halfWidth, self.position.y - halfHeight), 
		projectile_speed_to_use)
	$Projectiles.add_child(projectile_instance)
>>>>>>> Stashed changes


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
<<<<<<< Updated upstream
    # Load player stats file
    Globals.load_stats()
=======
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass
>>>>>>> Stashed changes
