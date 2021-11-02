extends "res://entities/triggers/base-trigger/base-trigger.gd"

export var goToLevel: int = 0

func _init() -> void:
    type = EntityTypeEnums.TRIGGER_TYPE.DIALOG

func _on_nextLevelTriggerArea_body_entered(_body: Node) -> void:
    $nextLevelTriggerArea/nextLevelTriggerCollider.set_deferred('disabled', true)
    Signals.emit_signal("next_level_trigger", goToLevel)
