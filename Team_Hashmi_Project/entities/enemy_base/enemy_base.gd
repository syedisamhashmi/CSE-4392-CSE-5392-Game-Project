extends KinematicBody2D

var velocity: Vector2 = Vector2.ZERO
var gravity: float = 900.0
var friction: float = 0.9

func _physics_process(delta: float) -> void:
    velocity.y += gravity * delta
    velocity.x *= friction;
    # Godot's built in function to determine final velocity
    velocity = move_and_slide(velocity, Vector2.UP)
    
func damage(knockback):
  damage_flash_effect()
  velocity.x += knockback

func damage_flash_effect():
  $damage_sound.play()
  $Enemy_Base_Image.material.set_shader_param("intensity", 0.75)
  yield(get_tree().create_timer(0.1), "timeout")
  $Enemy_Base_Image.material.set_shader_param("intensity", 0.0)
  
