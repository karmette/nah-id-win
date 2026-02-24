extends Control

@onready var rect: ColorRect = $ColorRect
@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	visible = false
	SignalBus.fade.connect(fadeio)
	SignalBus.player_death_fade.connect(player_death_fade)

func fadeio():
	visible = true
	anim.play("fade")
	await get_tree().create_timer(3).timeout
	anim.play_backwards("fade")
	visible = false

func player_death_fade():
	visible = true
	anim.play("player_death_fade")
	await anim.animation_finished
	visible = false
