extends Node2D

var is_following = true

func _ready():
	SignalBus.toggle_attacking.connect(_on_attacking_toggled)

func _on_attacking_toggled(state: bool):
	is_following = !state


func _process(delta):
	# Make the pivot node look at the mouse
	if is_following:
		look_at(get_global_mouse_position())
