extends KinematicBody2D

const DEATH = "DEATH" # METAL

# warning-ignore:unused_class_variable
export var id: String = "-1"
# warning-ignore:unused_class_variable
export(EntityTypeEnums.ENEMY_TYPE) var type = EntityTypeEnums.ENEMY_TYPE.NONE
# warning-ignore:unused_class_variable
export var baseHealth = 0
var hitOnPunchNum: int = 0
var health = 9999
var velocity: Vector2 = Vector2.ZERO
var gravity: float = 900.0
var friction: float = .95

var enemyDetails = {}

func _ready() -> void: 
    # warning-ignore:return_value_discarded
    Signals.connect("player_location_changed", self, "player_location_changed")
    enemyDetails = getNewEnemyDetails()

func player_location_changed(_position: Vector2):
    pass

func _physics_process(delta: float) -> void:
    if !Globals.inGame:
        return
    velocity.y += gravity * delta
    velocity.x *= friction;
    
    if abs(velocity.x) < 5 and is_on_floor():
        velocity = Vector2.ZERO
    # Godot's built in function to determine final velocity
    velocity = move_and_slide(velocity, Vector2.UP)
    
func damage(_damage: float, knockback, isPunch : bool  = false, punchNum = 0) -> bool:
    if !Globals.inGame:
        return false
    # Stops one punch from hitting multiple times.
    # If current punch # is the same as the one we were hit on
    if isPunch && punchNum == hitOnPunchNum:
        # Don't take damage.
        return false
    else:
        # This is a new punch, store current punch num
        hitOnPunchNum = punchNum
        
    # Determined that it is a new punch, so take damage 
    damage_flash_effect()
    
    # pushes the enemy away from the player depending on the projectile speed
    # also knocks the enemy slightly up into the air
    velocity.x += knockback
    velocity.y += -abs(knockback)
    return true

func damage_flash_effect():
    if !Globals.inGame:
        return
    $damage_sound.play()
    $Image.material.set_shader_param("intensity", 0.75)
    yield(get_tree().create_timer(0.1), "timeout")
    $Image.material.set_shader_param("intensity", 0.0)
  

func setupEnemyDetails():
    enemyDetails = getNewEnemyDetails()
    if PlayerData.savedGame.enemiesData.has(id):
        enemyDetails = PlayerData.savedGame.enemiesData[id]
        self.id = enemyDetails.id
        self.health = enemyDetails.health
        self.position.x = enemyDetails.posX
        self.position.y = enemyDetails.posY
        self.scale.x = enemyDetails.scaleX
        self.scale.x = enemyDetails.scaleY
    else:
        enemyDetails.id = id
        enemyDetails.health = health
        enemyDetails.posX = self.position.x
        enemyDetails.posY = self.position.y
        enemyDetails.scaleX = self.scale.x
        enemyDetails.scaleY = self.scale.y

func getNewEnemyDetails():
    return {
        "id": self.id,
        "health": 0,
        "posX": self.position.x,
        "posY": self.position.y,
        "scaleX": self.scale.x,
        "scaleY": self.scale.y
    }
func updateEnemyDetails(_id):
    if !PlayerData.savedGame.enemiesData.has(_id):
       PlayerData.savedGame.enemiesData[_id] = getNewEnemyDetails()
    PlayerData.savedGame.enemiesData[_id] = enemyDetails


func checkAlive():
    if (health <= 0):
        self.set_collision_mask_bit(1, false)
        self.set_collision_layer_bit(9, true)
        self.set_collision_layer_bit(2, false)
        $Image.set_animation(DEATH)
