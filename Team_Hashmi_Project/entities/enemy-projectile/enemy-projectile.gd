extends Node2D

var gravity: float = 10.0
var velocity: Vector2 = Vector2.ZERO

func init(positionP: Vector2, velocityP: Vector2) -> void:
    self.position = positionP
    self.velocity = velocityP

func _physics_process(delta: float) -> void:
    velocity.y += gravity * delta
    set_position(position + velocity)

func _on_ProjectileArea_body_entered(body: Node) -> void:
    # checks if body has method "damage" if so, call that method
    # the result depends on that collided body
    if body.has_method("damage"):
      body.damage(10, .2)
      
    self.queue_free()

