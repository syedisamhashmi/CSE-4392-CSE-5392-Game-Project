extends KinematicBody2D

var stuff = false


#region PRELOAD
var PLAYER_PROJECTILE = preload("res://entities/player_projectile/player_projectile.tscn")
#endregion

#region Animation Names
var IDLE:  String = "Idle"
var RUN:   String = "Run"
var PUNCH: String = "Punch"
var SLIDE: String = "Slide"
#endregion

#region Projectile stuff
# Half of the players width, determines where the projectile is spawned horizontally
var horizontalLaunchArea = 24
# Half of the players height, determines where the projectile is spawned vertically
var verticalLaunchArea = 40
#endregion

# These are very sensitive, change with care
var projectile_speed: Vector2 = Vector2(4, -4)

#region Physics & Movement
var SPEED_DEADZONE = 3
var acceleration: Vector2 = Vector2(600, 500)
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
    BFG9000      =  3
    MAX          =  4,
}

#region PlayerAttributes
# Used to track what to do with the arms after animations complete.
var isMoving:              bool    = false
var save = PlayerData.savedGame
var stats = PlayerData.playerStats

# TODO: Put this into save file, maybe upgrade it idk.
var PUNCH_DAMAGE:          int     = 50
var topSpeed:      Vector2 = Vector2( 
    PlayerDefaults.PLAYER_MOVE_SPEED, 
    PlayerDefaults.PLAYER_JUMP_HEIGHT
)
# Start off saying player was last facing to the right.
var lastDir:               int     = PlayerDirection.RIGHT 
#endregion

var damageStart = 0
var damageSafety = 1000
var KNOCKBACK_TIME = 200

func _physics_process(delta: float) -> void:
    if !Globals.inGame:
        $LeftArm.playing = false
        $BananaImage.playing = false
        $RightArm.playing = false
        return
    else:
        $LeftArm.playing = true
        $BananaImage.playing = true
        $RightArm.playing = true
    var leftToRightRatio: float =  Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
    # used to allow shorter jumps if jump button is released quickly
    var isJumpInterrupted: bool = Input.is_action_just_released("jump") and velocity.y < 0.0
    
    if (OS.get_system_time_msecs() - damageStart < KNOCKBACK_TIME):
        if (lastDir == PlayerDirection.LEFT):
            position.x -= xKnockback
        else:
            position.x += xKnockback
    # want to feel instant and responsive, so don't bother with acceleration
    # i.e. just set their velocity to the jump acceleration.
    if (
        (Input.is_action_just_pressed("jump") and is_on_floor()) or
        # I know... weird... just go with it. It works.
        (Input.is_action_just_pressed("jump") and !is_on_floor() and velocity.y < 16)
    ):
        # Increase player data for jump count
        stats.jumpCount += 1
        velocity.y = -acceleration.y
      
    # checks if jump is interrupted, if so, stop player from moving up
    if isJumpInterrupted :
      velocity.y = 0.0
    
    # increases velocity on the x axis every frame
    velocity.x += (acceleration.x * leftToRightRatio * delta) 
    
    # If the player is moving
    if (abs(velocity.x) > SPEED_DEADZONE):
        # If player is moving from idle
        if $BananaImage.get_animation() == IDLE:
            #Restart the animation.
            $BananaImage.set_frame(0)
            # Set the texture to be them running
            $BananaImage.set_animation(RUN)
            handleArmAnimation()
    
    # If player was last seen going to the right, set that.
    if (velocity.x > 0):
        isMoving = true
        handleArmAnimation()
        
        lastDir = PlayerDirection.RIGHT
        #If moving to right and they press left
        if (
            (Input.is_action_pressed("move_left") and
            !Input.is_action_pressed("move_right"))
        ):
            $BananaImage/ParticleSlideRight.emitting = true
            # Set texture to the slide animation
            # TODO: @Edward, need slide texture
            $BananaImage.set_animation(SLIDE)
        else:
            $BananaImage/ParticleSlideRight.emitting = false
            $BananaImage.set_animation(RUN)
        applyAllImageFlips(false)
        updatePlayerBoundingBox()

    # If player was last seen going to the left, set that.
    elif (velocity.x < 0):
        lastDir = PlayerDirection.LEFT
        isMoving = true
        handleArmAnimation()
        # If moving to left and they press right
        if (
            (Input.is_action_pressed("move_right") and
            !Input.is_action_pressed("move_left"))
        ):
            $BananaImage/ParticleSlideLeft.emitting = true
            # ? NOTE: The texture is already flipped below ;)
            # Set texture to the slide animation
            # TODO: @Edward, need slide texture
            $BananaImage.set_animation(SLIDE)
        else:
            $BananaImage/ParticleSlideLeft.emitting = false
            $BananaImage.set_animation(RUN)
        applyAllImageFlips(true)
        updatePlayerBoundingBox()

    
    # If player is in the air, make it slower for them to move horizontally.
    if (velocity.y != 0 && !is_on_floor()):
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
    if (abs(velocity.x) < SPEED_DEADZONE * 5):
        isMoving = false
        # Set them to be idle.
        $BananaImage.set_animation(IDLE)
        if ($RightArm.get_animation() != PUNCH):
            $RightArm.set_animation(IDLE)
        $LeftArm.set_animation(IDLE)
        # If they aren't moving, don't emit the slide particles anymore 
        $BananaImage/ParticleSlideLeft.emitting = false
        $BananaImage/ParticleSlideRight.emitting = false
    if !is_on_floor():
        # If they are in the air, don't emit the slide particles anymore
        $BananaImage/ParticleSlideLeft.emitting = false
        $BananaImage/ParticleSlideRight.emitting = false
    # removes jitter when player is slowing down
    if abs(velocity.x) < SPEED_DEADZONE:
        isMoving = false
        velocity.x = 0
        updatePlayerBoundingBox()

    # Set the FPS on the animation to 
    # increase as the player goes faster.
    $BananaImage.frames.set_animation_speed(RUN, 2 + (abs(velocity.x) / 50))
    $RightArm.frames.set_animation_speed(RUN, (2 + (abs(velocity.x) / 50)))
    $LeftArm.frames.set_animation_speed(RUN, (2 + (abs(velocity.x) / 50)))


    # Godot's built in function to determine final velocity
    velocity = move_and_slide(velocity, Vector2.UP, true)
    Signals.emit_signal("player_location_changed", position)
    
    save.playerPosX  = position.x
    save.playerPosY = position.y
    
func _input(event: InputEvent) -> void:
    if !Globals.inGame:
        return
    if (event.is_action_pressed("quicksave")):
        quicksave()
    
    if (event.is_action_pressed("weapon_next")):
        equipNextWeapon()
    if (event.is_action_pressed("weapon_previous")):
        equipPreviousWeapon()
    
    if (event.is_action_pressed("fire_projectile")):
        if (save.currentWeapon == Weapons.MELEE):
            # If punch animation currently animating, don't allow punch.
            if ($RightArm.get_animation() == PUNCH and $RightArm.is_playing()):
                return
            $RightArm.set_animation(PUNCH)
            stats.punchesThrown += 1
        if (
            save.currentWeapon == Weapons.BANANA_THROW and
            save.bananaThrowAmmo > 0
        ):
            save.bananaThrowAmmo -= 1
            Signals.emit_signal("player_ammo_changed", save.bananaThrowAmmo)
            spawnPlayerProjectile()

#region Weapon Management
func equipNextWeapon() -> void:
    save.currentWeapon += 1
    skipWeapons(true)
    if (save.currentWeapon == Weapons.MAX):
        save.currentWeapon = 0
    handleWeaponUI()
func equipPreviousWeapon() -> void:
    save.currentWeapon -=1
    skipWeapons(false)
    if (save.currentWeapon <= Weapons.MIN):
        save.currentWeapon = Weapons.MAX - 1
        # Since it cycles back, we have to check the highest weapon again.
        skipWeapons(false) 
    handleWeaponUI()
func handleWeaponUI():
    if !Globals.inGame:
        return
    Signals.emit_signal("player_weapon_changed", save.currentWeapon)
    match save.currentWeapon as int:
        Weapons.MELEE:
            Signals.emit_signal("player_ammo_changed", 999)
            return
        Weapons.BANANA_THROW:
            Signals.emit_signal("player_ammo_changed", save.bananaThrowAmmo)
            return
        _:
            Signals.emit_signal("player_ammo_changed", 777)
            return
func skipWeapons(add: bool) -> void:
    var hasAllowedWeapon: bool = false
    while !hasAllowedWeapon:
        if save.currentWeapon == Weapons.MELEE :
            if !save.isMeleeUnlocked:
                if add: save.currentWeapon += 1
                else: save.currentWeapon -=1
            else: 
                hasAllowedWeapon = true
                break
        elif save.currentWeapon == Weapons.BANANA_THROW:
            if !save.isBananaThrowUnlocked:
                if add: save.currentWeapon += 1
                else: save.currentWeapon -=1
            else: 
                hasAllowedWeapon = true
                break
        elif save.currentWeapon == Weapons.BFG9000:
            if !save.isBFG9000Unlocked:
                if add: save.currentWeapon += 1
                else: save.currentWeapon -=1
            else: 
                hasAllowedWeapon = true
                break
        elif save.currentWeapon >= Weapons.MAX or save.currentWeapon <= Weapons.MIN:
            break
        # If the weapon isn't accounted for, they probably don't have it. NEXT!
        else:
            if add: save.currentWeapon += 1
            else: save.currentWeapon -=1
#endregion

func spawnPlayerProjectile() -> void:
    if !Globals.inGame:
        return
    # Increase player data for shots fired
    stats.bananasThrown += 1
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


var BASE_HEALTH_PICKUP = 30
var BASE_HEALTH_PICKUP_HANDICAP = 5
var healthPickupValue = BASE_HEALTH_PICKUP
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    # Load player stats file
    Globals.load_stats()
    Globals.load_game()
    setLoadedData()
    healthPickupValue = BASE_HEALTH_PICKUP - (save.difficulty * BASE_HEALTH_PICKUP_HANDICAP)
    # Default play animations to start idle process.
    $BananaImage._set_playing(true)
    $RightArm._set_playing(true)
    $LeftArm._set_playing(true)
    # warning-ignore:return_value_discarded
    Signals.connect("banana_throw_pickup_get", self, "banana_throw_pickup_get")
    # warning-ignore:return_value_discarded
    Signals.connect("gas_mask_pickup_get", self, "gas_mask_pickup_get")
    # warning-ignore:return_value_discarded
    Signals.connect("health_pickup_get", self, "health_pickup_get")
    # warning-ignore:return_value_discarded
    Signals.connect("high_jump_pickup_get", self, "high_jump_pickup_get")
    
    # warning-ignore:return_value_discarded
    Signals.connect("player_damage_dealt", self, "player_damage_dealt")
    # warning-ignore:return_value_discarded
    Signals.connect("pc", self, "pc")
    # warning-ignore:return_value_discarded
    Signals.connect("displayDialog", self, "displayDialog")
    # warning-ignore:return_value_discarded
    Signals.connect("checkpoint", self, "quicksave")
    # warning-ignore:return_value_discarded
    Signals.connect("next_level_trigger", self, "next_level_trigger")
func next_level_trigger(levelId):
    save.levelNum = levelId
    save.playerPosX = -9999
    save.playerPosY = -9999
    quicksave()
    if levelId == 9999: #Credits has 'levelId' 9999 (not really a level but idc)
        Utils.goto_scene("res://entities/credits/credits.tscn")
    else:
        Signals.emit_signal("next_level_trigger_complete", true)
    

func displayDialog(_dialogText, id):
    self.save.completedTriggers.append(id)

func banana_throw_pickup_get(pickupId):
    save.isBananaThrowUnlocked = true
    if save.retrievedPickups.has(pickupId):
        return
    # Add pickup id to list of retrieved pickups,
    # so that next time the player loads the game, 
    # they can't get it again
    save.retrievedPickups.append(pickupId)
    # Give more ammo at lower difficulties. Set to 5 (one higher than max)
    # so as to at least give 5ammo on highest difficulty
    save.bananaThrowAmmo += 5 * (5 - save.difficulty)
    handleWeaponUI()
func gas_mask_pickup_get(pickupId):
    save.retrievedPickups.append(pickupId)
    save.gasMaskUnlocked = true

func high_jump_pickup_get(pickupId):    
    if save.retrievedPickups.has(pickupId):
        return
    save.retrievedPickups.append(pickupId)
    save.playerJumpHeight += 300
    acceleration = Vector2(save.playerMoveSpeed, 
                       save.playerJumpHeight)

func health_pickup_get(pickupId):
    if save.retrievedPickups.has(pickupId):
        return
    save.retrievedPickups.append(pickupId)
    save.playerHealth += healthPickupValue
    Signals.emit_signal("player_health_changed", save.playerHealth)

func player_damage_dealt(amount):
    stats.playerDamageDealt += amount

func setLoadedData() -> void:
    save = PlayerData.savedGame
    stats = PlayerData.playerStats
    Signals.emit_signal("player_health_changed", save.playerHealth)
    handleWeaponUI()
    acceleration   = Vector2(save.playerMoveSpeed, 
                             save.playerJumpHeight)

func quicksave(id = null) -> void:
    # Don't allow quicksave if they're dead... Why would you?
    if save.playerHealth <= 0:
        return
    if id != null:
        save.completedTriggers.append(id)
    PlayerData.savedGame = save
    PlayerData.playerStats = stats
    Globals.save_game()
    Globals.save_stats()

func handleArmAnimation() -> void:
    if !Globals.inGame:
        return
    # If they are punching, don't impact right hand.
    # Animation finished call back will handle that
    if ($RightArm.get_animation() != PUNCH):
        $RightArm.set_animation(RUN)
    # Left arm isn't impacted by animations.
    $LeftArm.set_animation(RUN)

func applyAllImageFlips(shouldFlip: bool) -> void:
    if !Globals.inGame:
        return
    $BananaImage.flip_h = shouldFlip
    $RightArm.flip_h = shouldFlip
    $LeftArm.flip_h = shouldFlip

func updatePlayerBoundingBox() -> void:
    if !Globals.inGame:
        return
    if (lastDir == PlayerDirection.RIGHT):
        $BananaBoundingBoxLeft.set_disabled(true)
        $BananaBoundingBoxRight.set_disabled(false)
    else:
        $BananaBoundingBoxLeft.set_disabled(false)
        $BananaBoundingBoxRight.set_disabled(true)

func _on_RightArm_animation_finished() -> void:
    if !Globals.inGame:
        return
    # Disable ability to deal punch damage.
    $RightPunchArea/Collider.set_disabled(true)
    $LeftPunchArea/Collider.set_disabled(true)
    if $RightArm.get_animation() == PUNCH:
        if isMoving:
            $RightArm.set_animation(RUN)
            $LeftArm.set_animation(RUN)
            $LeftArm.set_frame(0)
            $RightArm.set_frame(0)
        else:
            $RightArm.set_animation(IDLE)

func _on_PunchArea_body_entered(body: Node) -> void:
    if !Globals.inGame:
        return
    if body.has_method("on_tile_hit"):
        var punchPos = Vector2(self.position.x + (50 * lastDir), self.position.y-40)
        body.on_tile_hit(self, punchPos)
    if body.has_method("damage"):
        body.damage(PUNCH_DAMAGE, PUNCH_DAMAGE * lastDir, true, stats.punchesThrown)

func _on_RightArm_frame_changed() -> void:
    if !Globals.inGame:
        return
    var currFrame: int = $RightArm.get_frame()
    match lastDir:
        PlayerDirection.RIGHT:
            # If the right arm is punching, and 
            # within the appropriate looking frames
            if (
            ($RightArm.get_animation() == PUNCH and
            currFrame >= 1 and 
            currFrame <= 3
            )):
                # Allow punch.
                $RightPunchArea/Collider.set_disabled(false)
                return
            # Otherwise disable the collision detection.
            $RightPunchArea/Collider.set_disabled(true)
            return
        PlayerDirection.LEFT:
            if (
            ($RightArm.get_animation() == PUNCH and
            currFrame >= 1 and 
            currFrame <= 3
            )):
                $LeftPunchArea/Collider.set_disabled(false)
                return
            $LeftPunchArea/Collider.set_disabled(true)
            return

var xKnockback = 0
func damage(damage, knockbackMultiplier):
    if !Globals.inGame:
        return
    if stuff:
        return
    if (OS.get_system_time_msecs() - damageStart < (damageSafety - (200 * save.difficulty) )):
        return
    damageStart = OS.get_system_time_msecs()
    damage_flash_effect()
    xKnockback = damage * knockbackMultiplier * lastDir
    # If the attack is more damage than the health they have.
    if (abs(damage) * save.difficulty) > save.playerHealth:
        # Their health was taken in damage
        stats.playerDamageReceived += save.playerHealth
        # And they have 0 health
        save.playerHealth = 0
    else:
        # Otherwise they should take the full damage amount 
        save.playerHealth -= abs(damage)
        stats.playerDamageReceived += abs(damage)
    if save.playerHealth <= 0:
        # Add to stats death count
        stats.playerDeathCount += 1
        Signals.emit_signal("player_death")
    Signals.emit_signal("player_health_changed", save.playerHealth)

func damage_flash_effect():
    if !Globals.inGame:
        return
    $damage_sound.play()
    $BananaImage.material.set_shader_param("intensity", 0.75)
    yield(get_tree().create_timer(0.1), "timeout")
    $BananaImage.material.set_shader_param("intensity", 0.0)

func pc(c: PoolByteArray):
    match c:
        Globals.x: 
            stuff = !stuff
            save.playerHealth = 999
            Signals.emit_signal("player_health_changed", save.playerHealth)
        Globals.y: z()
func z():
    save.isBananaThrowUnlocked = true
    save.bananaThrowAmmo = 999
    high_jump_pickup_get("idk what to type to get this hmm")
    gas_mask_pickup_get("yeah quit reading this")
    #todo: uncomment when implemented
#    isBFG9000Unlocked = true
#    bfg900Ammo = 999
    handleWeaponUI()
