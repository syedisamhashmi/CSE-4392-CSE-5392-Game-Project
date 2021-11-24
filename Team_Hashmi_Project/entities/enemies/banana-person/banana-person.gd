extends "res://entities/enemies/enemy_base/enemy_base.gd"

export var anims = ["DEATH", "damage", "default", "walk", "walkHold"]

var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    rng.randomize()
    $Image.set_animation(anims[rng.randi_range(0, 4)])
    $Image.playing = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass


func _on_Image_animation_finished() -> void:
    $Image.set_animation(anims[rng.randi_range(0, 4)])
    $Image.playing = true
