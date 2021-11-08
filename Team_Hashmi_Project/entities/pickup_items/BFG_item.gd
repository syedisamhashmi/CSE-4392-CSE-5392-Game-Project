extends Area2D

export var signalName: String = "insert-signal-name-here"
export var id: String = ""
# warning-ignore:unused_class_variable
export(EntityTypeEnums.PICKUP_TYPE) var type = EntityTypeEnums.PICKUP_TYPE.NONE


func _on_pickup_body_entered(_body):
    if !Globals.inGame:
        return
    $Sprite.visible = false
    # play pickup sound
    $AudioStreamPlayer.play()
    # wait for pickup sound to end
    yield($AudioStreamPlayer, "finished")

    if signalName != "insert-signal-name-here":
        Signals.emit_signal(signalName, id)

    queue_free()
