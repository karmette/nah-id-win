extends Control

@export var selected: bool = false
@export var weapon_texture: Texture2D
@export var weapon: String

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: TextureRect = $Slot/Weapon
@onready var progress: TextureProgressBar = $Slot/TextureProgressBar

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
	GlobalVar.on_weapon_cooldown = true


func _process(_delta):
	if selected != temp_selected:
		selected_changed.emit()
	temp_selected = selected
	progress.value = GlobalVar.cd_timer * 60
	if GlobalVar.on_weapon_cooldown == false:
		progress.value = 0
		GlobalVar.cd_timer = 0
	if weapon in GlobalVar.unlocked_weapons:
		visible = true
	else:
		visible = false
