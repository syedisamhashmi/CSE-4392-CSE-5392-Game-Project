extends "res://entities/triggers/base-trigger/base-trigger.gd"

func _init() -> void:
    type = EntityTypeEnums.TRIGGER_TYPE.CHECKPOINT

func _on_checkpointTriggerArea_body_entered(_body: Node) -> void:
    $checkpointTriggerArea/checkpointTriggerCollider.set_deferred('disabled', true)
    Signals.emit_signal("checkpoint", id)

