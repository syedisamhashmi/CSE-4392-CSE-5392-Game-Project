extends KinematicBody2D

var gravity = 10
var friction = 62
var velocity = Vector2(0,0)
var direction = 1

func _ready():
	$Image.play("walk")
	
func _process(_delta):
	move_character()
	
func move_character():
	velocity.x = friction * direction
	velocity.y += gravity
	
	velocity = move_and_slide(velocity)
	
	if is_on_wall():
		direction = direction * -1
	
	

