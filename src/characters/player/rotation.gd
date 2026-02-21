extends Node2D

var is_following = true

func _ready():
	SignalBus.toggle_attacking.connect(_on_attacking_toggled)

func _on_attacking_toggled(state: bool):
	is_following = !state


func _process(delta):
	var mouse_position = get_global_mouse_position() # Get mouse world position
	
	if is_following:
		look_at(mouse_position)
		
	if mouse_position.x > self.global_position.x and is_following:
		self.scale.y = 1 
	elif mouse_position.x < self.global_position.x and is_following:
		self.scale.y = -1
