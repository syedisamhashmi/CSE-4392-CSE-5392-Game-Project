extends Area2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#  pass


func _on_banana_item_body_entered(_body: Node) -> void:
  PlayerData.setIsBananaThrowUnlocked(true)
  queue_free()
  pass # Replace with function body.