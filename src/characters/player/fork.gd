extends Node2D

@onready var animation_player: AnimationPlayer = $ForkSprite/AnimationPlayer
var attacking = false

func _input(event):
	if Input.is_action_pressed("attack"):
		attack()

func attack():
	animation_player.play("swing")
