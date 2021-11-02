extends "res://entities/triggers/base-trigger/base-trigger.gd"

export var dialogText: String = "Overwrite me!"

func _process(_delta: float) -> void:
    $ColorRect.visible = Globals.SHOW_TRIGGERS

func _init() -> void:
    type = EntityTypeEnums.TRIGGER_TYPE.DIALOG

func _on_dialogTriggerArea_body_entered(_body: Node) -> void:
    $dialogTriggerArea/dialogTriggerCollider.set_deferred('disabled', true)
    Signals.emit_signal("displayDialog", dialogText, id)

