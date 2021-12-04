extends Area2D

var active = false

func _ready():
# warning-ignore:return_value_discarded
	connect("body_entered", self, '_on_NPC_body_entered')
# warning-ignore:return_value_discarded
	connect("body_exited", self, '_on_NPC_body_exited')
	

# warning-ignore:unused_argument
func _process(delta):
	$Dialog.visible = active
	
func _input(event):
	if get_node_or_null('DialogNode') == null:
		if event.is_action_pressed("ui_accept") and active:
			get_tree().paused =  true
			var Dialog = Dialogic.start('timeline-1')
			Dialog.pause_mode = Node.PAUSE_MODE_PROCESS
			Dialog.connect('timeline_end', self, 'unpause')
			add_child(Dialog)
			
# warning-ignore:unused_argument
func unpause(timeline_name):
	get_tree().paused = false


func _on_NPC_body_entered(body):
	if body.name == 'Banana':
		active = true
		

func _on_NPC_body_exited(body):
	if body.name == 'Banana':
		active = false
