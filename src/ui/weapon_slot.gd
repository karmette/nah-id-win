extends Control

@export var selected: bool = false
@export var weapon_texture: Texture2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: TextureRect = $Slot/Weapon

var temp_selected: bool = false
signal selected_changed

func _ready() -> void:
	selected_changed.connect(select)
	sprite.texture = weapon_texture

func select():
	if selected:
		anim.play("select")
	else:
		anim.play_backwards("select")


func _process(_delta):
	if selected != temp_selected:
		selected_changed.emit()
	temp_selected = selected
