extends Node2D

var perDeltaRotAngle: float = PI / 16
var gravity: float = 10.0
var velocity: Vector2 = Vector2.ZERO

func init(positionP: Vector2, velocityP: Vector2) -> void:
    self.position = positionP
    self.velocity = velocityP

func _process(delta: float) -> void:
    $player_projectile_image.transform = $player_projectile_image.transform.rotated(perDeltaRotAngle)
    velocity.y += gravity * delta
    position += velocity

func _on_projectile_area_body_entered(body: Node) -> void:
    #TODO: do something to the enemy, make them lose health, etc.
    if body.has_method("damage"):
      body.damage(25)
    self.queue_free()


