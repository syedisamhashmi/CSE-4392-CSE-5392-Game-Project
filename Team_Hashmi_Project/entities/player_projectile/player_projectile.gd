extends Node2D

var perDeltaRotAngle: float = PI / 32
var gravity: float = 10.0
var velocity: Vector2 = Vector2.ZERO
var projectileDamage = 10
func init(positionP: Vector2, velocityP: Vector2) -> void:
    self.position = positionP
    self.velocity = velocityP

func _physics_process(delta: float) -> void:
    $player_projectile_image.transform = $player_projectile_image.transform.rotated(perDeltaRotAngle)
    velocity.y += gravity * delta
    set_position(position + velocity)


func _on_projectile_area_body_entered(body: Node) -> void:
    #TODO: do something to the enemy, make them lose health, etc.
    
    # the enemy knockback is determined by the projectile velocity multiplied by a scalar
    var knockback_scaling = 10;
    var knockback = knockback_scaling * velocity.x;
    
    # checks if body has method "damage" if so, call that method
    # the result depends on that collided body
    if body.has_method("damage"):
      body.damage(projectileDamage, knockback, false)
      
    self.queue_free()


