extends Node2D

@onready var animation_player: AnimationPlayer = $ForkSprite/AnimationPlayer
@onready var fork_sprite: Sprite2D = $ForkSprite

var on_cooldown = false
var damage = 5
var player: Node2D

func _ready():
	SignalBus.toggle_attacking.connect(_on_attacking_toggled)
	player = get_tree().get_first_node_in_group("player")

func _on_attacking_toggled(state: bool):
	on_cooldown = state

func _input(event):
	if Input.is_action_just_pressed("swing") and not on_cooldown:
		animation_player.play("swing")
	if Input.is_action_pressed("thrust") and not on_cooldown:
		animation_player.play("charge_thrust")
	if Input.is_action_just_released("thrust") and not on_cooldown:
		animation_player.play("thrust")
		player.dash((get_global_mouse_position() - global_position).normalized())

#Signals
func emit_attacking(state: bool):
	SignalBus.toggle_attacking.emit(state)
	
func _on_hitbox_area_entered(area: Area2D) -> void:
	var enemy = area.get_parent()

	if enemy.has_method("take_damage"):
		var direction = (enemy.global_position - global_position).normalized()
		enemy.take_damage(damage, direction)
