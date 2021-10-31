extends Node2D
export var id: String = "overwriteMe"
export var dialogText: String = "Overwrite me!"

func _on_dialogTriggerArea_body_entered(_body: Node) -> void:
    $dialogTriggerArea/dialogTriggerCollider.set_deferred('disabled', true)
    Signals.emit_signal("displayDialog", dialogText, id)

