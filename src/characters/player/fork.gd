extends Node2D

@onready var animation_player: AnimationPlayer = $ForkSprite/AnimationPlayer
var on_cooldown = false
@onready var fork_sprite: Sprite2D = $ForkSprite

func _ready():
	SignalBus.toggle_attacking.connect(_on_attacking_toggled)

func _on_attacking_toggled(state: bool):
	on_cooldown = state

func _input(event):
	if Input.is_action_pressed("attack") and not on_cooldown:
		attack()

func attack():
	animation_player.play("swing")

#Signals
func emit_attacking(state: bool):
	SignalBus.toggle_attacking.emit(state)
	
