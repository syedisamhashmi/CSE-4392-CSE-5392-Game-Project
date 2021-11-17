extends Node2D

var velocity: Vector2 = Vector2.ZERO

func init(positionP: Vector2, velocityP: Vector2) -> void:
    self.position = positionP
    self.velocity = velocityP
    if velocity.sign().x < 0:
        $AnimatedSprite.flip_h = true
        $first/firstColl.set_deferred("disabled", true)
        $firstR/firstColl.set_deferred("disabled", false)
    $AnimatedSprite.playing = true

func _physics_process(_delta: float) -> void:
    if !Globals.inGame:
        return
    set_position(position + velocity)

func _on_ProjectileArea_body_entered(body: Node) -> void:
    if !Globals.inGame:
        return
    # checks if body has method "damage" if so, call that method
    # the result depends on that collided body
    if body.has_method("damage"):
      body.damage(10 * velocity.sign().x, 2)
    self.queue_free()

func _on_AnimatedSprite_frame_changed() -> void:
    var currFrame = $AnimatedSprite.get_frame()
    if currFrame == 1:
        if velocity.sign().x < 0:
            $firstR/firstColl.set_deferred("disabled", true)
            $secondR/seccondColl.set_deferred("disabled", false)
            $thirdR/thirdColl.set_deferred("disabled", true)
            
            $first/firstColl.set_deferred("disabled", true)
            $second/seccondColl.set_deferred("disabled", true)
            $third/thirdColl.set_deferred("disabled", true)
        else:
            $firstR/firstColl.set_deferred("disabled", true)
            $secondR/seccondColl.set_deferred("disabled", true)
            $thirdR/thirdColl.set_deferred("disabled", true)
            
            $first/firstColl.set_deferred("disabled", true)
            $second/seccondColl.set_deferred("disabled", false)
            $third/thirdColl.set_deferred("disabled", true)
    if currFrame == 2:
        if velocity.sign().x < 0:
            $firstR/firstColl.set_deferred("disabled", true)
            $secondR/seccondColl.set_deferred("disabled", true)
            $thirdR/thirdColl.set_deferred("disabled", false)
            
            $first/firstColl.set_deferred("disabled", true)
            $second/seccondColl.set_deferred("disabled", true)
            $third/thirdColl.set_deferred("disabled", true)
        else:
            $first/firstColl.set_deferred("disabled", true)
            $second/seccondColl.set_deferred("disabled", true)
            $third/thirdColl.set_deferred("disabled", true)
            
            $first/firstColl.set_deferred("disabled", true)
            $second/seccondColl.set_deferred("disabled", true)
            $third/thirdColl.set_deferred("disabled", false)
        
