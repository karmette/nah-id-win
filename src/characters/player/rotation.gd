extends Node2D

func _process(delta):
	# Make the pivot node look at the mouse
	look_at(get_global_mouse_position())
