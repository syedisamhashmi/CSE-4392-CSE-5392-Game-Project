extends AudioStreamPlayer

func _on_BFG9000_finished():
    queue_free()

func _on_Blaster_finished():
    queue_free()

func _on_FallSoundEffect_finished():
    queue_free()

func _on_Jump_finished():
    queue_free()

func _on_PunchSoundEffect_finished():
    queue_free()

func _on_Throw_finished():
    queue_free()


