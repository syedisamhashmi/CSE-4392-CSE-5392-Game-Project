extends Node2D

var textPlay = false
var weMadeItPctVisible = 0.0
var toBeContPctVisible = 0.0
var animDone = false
func _ready() -> void:
    textPlay = true
    $ScaledCont/BG.playing = true
#    $AudioStreamPlayer2D.play(1.3)

func _process(delta: float) -> void:
    if textPlay and weMadeItPctVisible < 1:
        weMadeItPctVisible += .1 * delta * 4
        $WeMadeIt.set_deferred("percent_visible", weMadeItPctVisible)
    if textPlay and weMadeItPctVisible >= 1 and animDone:
        if textPlay and toBeContPctVisible < 1:
            toBeContPctVisible += .1 * delta * 4
            $ToBeCont.set_deferred("percent_visible", toBeContPctVisible)
        if textPlay and toBeContPctVisible > 1:
            $Continue.set_deferred("disabled", false)
            $Continue.set_deferred("visible", true)
func _on_Continue_pressed() -> void:
    Utils.current_scene = self
    Utils.goto_scene("res://entities/MainMenu.tscn")


func _on_BG_animation_finished() -> void:
    animDone = true
