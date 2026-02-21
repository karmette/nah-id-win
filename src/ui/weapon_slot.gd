extends Control

@export var selected: bool = false
@onready var anim: AnimationPlayer = $AnimationPlayer
var temp_selected: bool = false
signal selected_changed

func _ready() -> void:
	selected_changed.connect(select)

func select():
	if selected:
		anim.play_backwards("select")
	else:
		anim.play("select")


func _process(_delta):
	if selected != temp_selected:
		selected_changed.emit()
	temp_selected = selected