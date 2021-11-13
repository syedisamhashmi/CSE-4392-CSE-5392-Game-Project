extends Node

export var signalName: String = "insert-signal-name-here"
export var id: String = ""
# warning-ignore:unused_class_variable
export(EntityTypeEnums.PICKUP_TYPE) var type = EntityTypeEnums.PICKUP_TYPE.NONE

func _on_pickup_body_entered(_body: Node) -> void:
    if !Globals.inGame:
        return
    $Sprite.visible = false
    # play pickup sound
    $AudioStreamPlayer.play()
    # Disable further collisions
    $CollisionShape2D.set_deferred("disabled", true)
    # Make it invisible so it doesn't bother anyone
    $Sprite.set_deferred("visible", false)
    # Emit signal so everyone knows this occurred
    if signalName != "insert-signal-name-here":
        Signals.emit_signal(signalName, id)
    # wait for pickup sound to end AFTER emmiting signal
    # this won't cause a hold-up on the UI updating
    yield($AudioStreamPlayer, "finished")

    queue_free()
