extends Node2D

var textPlay = false
var pctVisible = 0.0

func _ready() -> void:
    $ScaledCont/BG.playing = true
    $AudioStreamPlayer2D.play(1.3)

func _process(delta: float) -> void:
    if textPlay and pctVisible < 1:
        pctVisible += .1 * delta * 2
        $Text.set_deferred("percent_visible", pctVisible)
    if textPlay and pctVisible >= 1:
        $Continue.set_deferred("disabled", false)
        $Continue.set_deferred("visible", true)

func _on_BG_animation_finished() -> void:
    textPlay = true

func _on_Continue_pressed() -> void:
    Utils.goto_scene("res://entities/Main.tscn")
