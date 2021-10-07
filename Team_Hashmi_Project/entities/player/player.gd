extends KinematicBody2D

#region PRELOAD
var PLAYER_PROJECTILE = preload("res://entities/player_projectile/player_projectile.tscn")
var BANANA_RUN = preload("res://entities/player//banana_run.tres")
var BANANA_IDLE = preload("res://entities/player//banana_idle.tres")

#endregion

#region Player Atlas stuff
# Half of the players width, determines where the projectile is spawned horizontally
var horizontalLaunchArea = 24 
#var fullWidthOfPlayer = 64 
# Half of the players height, determines where the projectile is spawned vertically
var verticalLaunchArea = 40
#var fullHeightOfPlayer = 64 

#var rightFace = Rect2(Vector2(0,0), Vector2(fullWidthOfPlayer, fullHeightOfPlayer))
#var leftFace = Rect2(Vector2(fullWidthOfPlayer, 0), Vector2(fullWidthOfPlayer, fullHeightOfPlayer))
#endregion

# These are very sensitive, change with care
var projectile_speed: Vector2 = Vector2(4, -4)

#region Physics & Movement
var SPEED_DEADZONE = 3
var acceleration: Vector2 = Vector2(600, 400)
var airControlModifier: Vector2 = Vector2(0.95, 0.0)
var friction: float = 0.90
var velocity: Vector2 = Vector2.ZERO
var gravity: float = 900.0
#endregion

# Player can only be facing one of these two directions.
enum PlayerDirection {
    LEFT  = -1,
    UH_OH = 0
    RIGHT =  1,   
}

enum Weapons {
    MIN          = -1
    MELEE        =  0,
    BANANA_THROW =  1,
    BANANA_GUN   =  2,
    MAX          =  3,
}

#region PlayerAttributes
var playerHealth:          float   = PlayerDefaults.DEFAULT_PLAYER_HEALTH
var currentWeapon:         int     = PlayerDefaults.DEFAULT_WEAPON
var isMeleeUnlocked:       bool    = PlayerDefaults.IS_MELEE_UNLOCKED
var isBananaThrowUnlocked: bool    = PlayerDefaults.IS_BANANA_THROW_UNLOCKED
var topSpeed:      Vector2 = Vector2( 
    PlayerDefaults.PLAYER_MOVE_SPEED, 
    PlayerDefaults.PLAYER_JUMP_HEIGHT
)
# Start off saying player was last facing to the right.
var lastDir:               int     = PlayerDirection.RIGHT 
#endregion

func _physics_process(delta: float) -> void:
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
    
    # If the player is moving
    if (abs(velocity.x) > SPEED_DEADZONE):
        # Set the texture to be them running
        $BananaImage.set_texture(BANANA_RUN)
        # If it was paused (from idle)
        if $BananaImage.get_texture().get_pause():
            #Restart the animation, and unpause it.
            $BananaImage.get_texture().set_current_frame(0)
            $BananaImage.get_texture().set_pause(false)
    
    # If player was last seen going to the right, set that.
    if (velocity.x > 0):
        lastDir = PlayerDirection.RIGHT
        # Undo any flip to the image
        $BananaImage.flip_h = false
        #Disable the left bounding box, and enable the right one
        $BananaBoundingBoxLeft.set_disabled(true)
        $BananaBoundingBoxRight.set_disabled(false)
    # If player was last seen going to the left, set that.
    elif (velocity.x < 0):
        lastDir = PlayerDirection.LEFT
        # Apply flip to the image
        $BananaImage.flip_h = true
        #Disable the left bounding box, and enable the right one
        $BananaBoundingBoxLeft.set_disabled(false)
        $BananaBoundingBoxRight.set_disabled(true)

    
    # If player is in the air, make it slower for them to move horizontally.
    if (velocity.y != 0):
        velocity.x *= airControlModifier.x
        
    
    velocity.y += gravity * delta
  
    # clamp velocity
    # Nice call Edward! - Isam
    velocity.x = clamp(velocity.x, -topSpeed.x, topSpeed.x)

    # Only apply friction if they aren't trying to move
    if ((!Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"))
    # or if they hit both buttons, I know it sounds weird, but it feels right?
    or (Input.is_action_pressed("move_left") and Input.is_action_pressed("move_right"))
    ):
        velocity.x *= friction
    
    # ? For when the player is slowing down,
    # ? If the player is (appearing) to not move
    # ? The speed is small enough that the eye can't see it move
    # ? stops the animation from looking horrible
    if (abs(velocity.x) < SPEED_DEADZONE * 25):
        # Set them to be idle.
        $BananaImage.set_texture(BANANA_IDLE)
    # removes jitter when player is slowing down
    if abs(velocity.x) < SPEED_DEADZONE:
        velocity.x = 0
        if (lastDir == PlayerDirection.RIGHT):
            $BananaBoundingBoxLeft.set_disabled(true)
            $BananaBoundingBoxRight.set_disabled(false)
        else:
            $BananaBoundingBoxLeft.set_disabled(false)
            $BananaBoundingBoxRight.set_disabled(true)

    # Set the FPS on the animation to increase as 
    # the player goes faster.
    $BananaImage.get_texture().set_fps(2 + (abs(velocity.x) / 50))
    # Godot's built in function to determine final velocity
    velocity = move_and_slide(velocity, Vector2.UP)
    
func _input(event: InputEvent) -> void:
    if (event.is_action_pressed("quicksave")):
        quicksave()
    
    if (event.is_action_pressed("weapon_next")):
        equipNextWeapon()
    if (event.is_action_pressed("weapon_previous")):
        equipPreviousWeapon()
    
    if (event.is_action_pressed("fire_projectile")):
        if (currentWeapon == Weapons.MELEE):
            print("Player punched")
            PlayerData.setPunchesThrown(PlayerData.getPunchesThrown() + 1)
        if (currentWeapon == Weapons.BANANA_THROW):
            print("Player threw banana")
            spawnPlayerProjectile()
        pass

#region Weapon Management
func equipNextWeapon() -> void:
    currentWeapon += 1
    skipWeapons(true)
    if (currentWeapon == Weapons.MAX):
        currentWeapon = 0
    print("Player switched to next weapon " + str(currentWeapon))
func equipPreviousWeapon() -> void:
    currentWeapon -=1
    skipWeapons(false)
    if (currentWeapon <= Weapons.MIN):
        currentWeapon = Weapons.MAX - 1
        # Since it cycles back, we have to check the highest weapon again.
        skipWeapons(false) 
    print("Player switched to previous weapon " + str(currentWeapon))
func skipWeapons(add: bool) -> void:
    var hasAllowedWeapon: bool = false
    while !hasAllowedWeapon:
        if currentWeapon == Weapons.MELEE :
            if !PlayerData.getIsMeleeUnlocked():
                if add: currentWeapon += 1
                else: currentWeapon -=1
            else: 
                hasAllowedWeapon = true
                break
        elif currentWeapon == Weapons.BANANA_THROW:
            if !PlayerData.getIsBananaThrowUnlocked():
                if add: currentWeapon += 1
                else: currentWeapon -=1
            else: 
                hasAllowedWeapon = true
                break
        elif currentWeapon >= Weapons.MAX or currentWeapon <= Weapons.MIN:
            break
        # If the weapon isn't accounted for, they probably don't have it. NEXT!
        else:
            if add: currentWeapon += 1
            else: currentWeapon -=1
#endregion

func spawnPlayerProjectile() -> void:
    # Increase player data for shots fired
    PlayerData.setBananasThrown(PlayerData.getBananasThrown() + 1)
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    # Load player stats file
    Globals.load_stats()
    Globals.load_game()
    setLoadedData()

    # ? Connect the exit_game signal to save the game
    # ? This way, before the game exits, the game state is saved.
    # warning-ignore:return_value_discarded
    Signals.connect("exit_game", self, "quicksave")


func setLoadedData() -> void:
    playerHealth = PlayerData.getPlayerHealth()
    currentWeapon = PlayerData.getCurrentWeapon()
    isMeleeUnlocked = PlayerData.getIsMeleeUnlocked()
    isBananaThrowUnlocked = PlayerData.getIsBananaThrowUnlocked()
    topSpeed = Vector2(PlayerData.getPlayerMoveSpeed(), PlayerData.getPlayerJumpHeight())
func quicksave() -> void:
    PlayerData.setPlayerHealth(playerHealth)
    PlayerData.setCurrentWeapon(currentWeapon)
    PlayerData.setIsMeleeUnlocked(isMeleeUnlocked)
    PlayerData.setIsBananaThrowUnlocked(isBananaThrowUnlocked)
    PlayerData.setPlayerMoveSpeed(topSpeed.x)
    PlayerData.setPlayerJumpHeight(topSpeed.y)
    Globals.save_game()
    Globals.save_stats()
