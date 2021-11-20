extends "res://entities/triggers/base-trigger/base-trigger.gd"

export(AudioStream) var song: AudioStream

func _process(_delta: float) -> void:
    $ColorRect.visible = Globals.SHOW_TRIGGERS

func _init() -> void:
    type = EntityTypeEnums.TRIGGER_TYPE.MUSIC

func _on_musicTriggerArea_body_entered(_body: Node) -> void:
    $musicTriggerArea/musicTriggerCollider.set_deferred('disabled', true)
    Signals.emit_signal("music_trigger", self.id, song)
