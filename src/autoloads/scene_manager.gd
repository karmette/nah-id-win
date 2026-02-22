extends Node

var current_scene = null


func _ready():
	init_current_scene()
	#add_ui_to_root.call_deferred(Constants.UI.weapon_switcher)


func init_current_scene():
	var root = get_tree().root
	# Using a negative index counts from the end, so this gets the last child node of `root`.
	current_scene = root.get_child(-1)
	print(current_scene)

func _deferred_goto_scene(path):
	current_scene.free()
	
	# Load the new scene.
	var s = ResourceLoader.load(path).duplicate()

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)
	return
func goto_scene(path):
	_deferred_goto_scene.call_deferred(path)

#func add_ui_to_root(path: String):
	#var root = get_tree().root
#
	#var s = ResourceLoader.load(path).instantiate()
#
	#root.add_child(s)
	
