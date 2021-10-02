extends KinematicBody2D

var velocity: Vector2 = Vector2.ZERO
var gravity: float = 900.0

func _physics_process(delta: float) -> void:
    velocity.y += gravity * delta
    # Godot's built in function to determine final velocity
    velocity = move_and_slide(velocity, Vector2.UP)
    
func damage(knockback):
  velocity.x += knockback
