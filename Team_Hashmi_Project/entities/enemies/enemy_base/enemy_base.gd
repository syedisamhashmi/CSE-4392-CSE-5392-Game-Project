extends KinematicBody2D

const DEATH = "DEATH" # METAL

# warning-ignore:unused_class_variable
export var id: String = "-1"
# warning-ignore:unused_class_variable
export(EntityTypeEnums.ENEMY_TYPE) var type = EntityTypeEnums.ENEMY_TYPE.NONE
export(EntityTypeEnums.PICKUP_TYPE) var itemDroptype = EntityTypeEnums.PICKUP_TYPE.NONE

export var alreadyDroppedItem: bool = false
# warning-ignore:unused_class_variable
export var dropsOnDifficulties =  {
    Strings.DIFFICULTIES.CAN_I_PLAY_DADDY      : false,
    Strings.DIFFICULTIES.IM_TOO_SQUISHY_TO_DIE : false,
    Strings.DIFFICULTIES.BRUISE_ME_PLENTY      : false,
    Strings.DIFFICULTIES.I_AM_BANANA_INCARNATE : false
}
   

# warning-ignore:unused_class_variable
export var baseHealth = 0
var hitOnPunchNum: int = 0
var health = 9999
var velocity: Vector2 = Vector2.ZERO
var gravity: float = 900.0
var friction: float = .95

var usePhys = true
func _ready() -> void: 
    # warning-ignore:return_value_discarded
    Signals.connect("player_location_changed", self, "player_location_changed")

func player_location_changed(_position: Vector2):
    pass

func _physics_process(delta: float) -> void:
    if !Globals.inGame:
        return
    if !usePhys:
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
  


func updateEnemyDetails(_id):
    var enemyDetails = {}
    enemyDetails.id = self.id
    enemyDetails.health = self.health 
    enemyDetails.posX = self.position.x
    enemyDetails.posY = self.position.y
    enemyDetails.scaleX = self.scale.x
    enemyDetails.scaleY = self.scale.y
    enemyDetails.alreadyDroppedItem = self.alreadyDroppedItem
    enemyDetails.dropsOnDifficulties = self.dropsOnDifficulties
    enemyDetails.itemDroptype = self.itemDroptype
    if ("deployed" in self):
        enemyDetails.deployed = self.deployed
    Signals.emit_signal("update_enemy", enemyDetails)


func checkAlive():
    if (health <= 0):
        if (!alreadyDroppedItem):
            if dropsOnDifficulties.get(Strings.DIFFICULTIES_STR[PlayerData.savedGame.difficulty]):
                if (itemDroptype == null or itemDroptype == EntityTypeEnums.PICKUP_TYPE.NONE):
                    pass
                else:
                    var newItem = {
                        "type": itemDroptype,
                        "posX": self.position.x,
                        "posY": self.position.y,
                        "id": self.id + "death",
                        "enemyId": self.id
                       }
                    Signals.emit_signal("enemy_pickup_spawn", newItem, true)
                    alreadyDroppedItem = true
                    updateEnemyDetails(self.id)
        self.set_collision_mask_bit(1, false)
        self.set_collision_layer_bit(9, true)
        self.set_collision_layer_bit(2, false)
        $Image.set_animation(DEATH)
