extends Node2D

var perDeltaRotAngle: float = PI / 32
var gravity: float = 10.0
var velocity: Vector2 = Vector2.ZERO
var projectileDamage = 10
var isBananaBlasterShot = false
var isBFG9000Shot = false
func init(positionP: Vector2, velocityP: Vector2) -> void:
    self.position = positionP
    self.velocity = velocityP

func _physics_process(delta: float) -> void:
    $player_projectile_image.transform = $player_projectile_image.transform.rotated(perDeltaRotAngle)
    velocity.y += gravity * delta
    set_position(position + velocity)


func _on_projectile_area_body_entered(body: Node) -> void:
    # the enemy knockback is determined by the projectile velocity multiplied by a scalar
    var knockback_scaling = 4;
    var knockback = knockback_scaling * velocity.x;
    
    # checks if body has method "damage" if so, call that method
    # the result depends on that collided body
    if body.has_method("on_tile_hit"):
        body.on_tile_hit(self, self.position)
        
    if body.has_method("damage"):
        var calcDmg = projectileDamage
        if isBananaBlasterShot:
            calcDmg *= 4
        if isBFG9000Shot:
            calcDmg *= 7
        body.damage(calcDmg, knockback)
      
    self.queue_free()


