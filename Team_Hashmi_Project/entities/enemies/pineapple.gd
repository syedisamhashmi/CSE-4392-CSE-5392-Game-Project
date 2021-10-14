extends KinematicBody2D

var velocity: Vector2 = Vector2.ZERO
var gravity: float = 900.0
var friction: float = 0.9

func _physics_process(delta: float) -> void:
    velocity.y += gravity * delta
    velocity.x *= friction;
    
    if velocity.x == 0:
      $AnimatedSprite.play("Idle")
    
    # Godot's built in function to determine final velocity
    velocity = move_and_slide(velocity, Vector2.UP)
    
func damage(knockback):
  damage_flash_effect()
  
  # pushes the enemy away from the player depending on the projectile speed
  # also knocks the enemy slightly up into the air
  velocity.x += knockback
  velocity.y += -abs(knockback)


func damage_flash_effect():
  print("hit!")
  $AudioStreamPlayer.play()
  $AnimatedSprite.material.set_shader_param("intensity", 0.75)
  yield(get_tree().create_timer(0.1), "timeout")
  $AnimatedSprite.material.set_shader_param("intensity", 0.0)
