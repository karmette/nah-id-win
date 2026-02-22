extends Control

@onready var rect: ColorRect = $ColorRect
@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	visible = false
	SignalBus.fade.connect(fadeio)

func fadeio():
	visible = true
	anim.play("fade")
	await get_tree().create_timer(3).timeout
	anim.play_backwards("fade")
	visible = false
