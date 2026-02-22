extends Node2D

@onready var animation_player: AnimationPlayer = $AnimatedSprite2D/AnimationPlayer
const bullet = preload("res://cheese_bullet.tscn")
@onready var bullet_spawn: Marker2D = $AnimatedSprite2D/BulletSpawn

var active = false
var on_cooldown = false
var player: Node2D
@export var charged = false

var shot_normal_recoil_force = 500
var shot_charged_recoil_force = 750

func _ready():
	SignalBus.toggle_attacking.connect(_on_attacking_toggled)
	SignalBus.changed_weapon_to.connect(_on_active_toggled)
	player = get_tree().get_first_node_in_group("player")

func _on_attacking_toggled(state: bool):
	on_cooldown = state

func _on_active_toggled(weapon: String):
	if weapon == "blue_cheese":
		active = true
		self.visible = true
	else:
		active = false
		self.visible = false
		
func emit_attacking(state: bool):
	SignalBus.toggle_attacking.emit(state)
	
func emit_screen_shake(intensity: int, time: float):
	SignalBus.shake_camera.emit(intensity, time)
	
func recoil_player(type: String):
	if type == "charged":
		player.dash(-(global_transform.x.normalized()), shot_charged_recoil_force)
	elif type == "normal":
		player.dash(-(global_transform.x.normalized()), shot_normal_recoil_force)
	
	
func toggle_player_movement(able_to_move: bool):
	player.can_move = able_to_move
	if not able_to_move:
		player.velocity = Vector2.ZERO
	
func change_player_speed(amount: int):
	player.speed = amount

func _input(event):
	if active:
		if Input.is_action_just_pressed("shoot") and not on_cooldown:
			animation_player.play("shoot")
			
		if Input.is_action_pressed("charge_shoot") and not on_cooldown:
			animation_player.play("charging_shoot")
	
		if Input.is_action_just_released("charge_shoot") and not on_cooldown:
			animation_player.play("RESET")
			change_player_speed(400)

func spawn_bullet(type: String):
	var current_bullet = bullet.instantiate()
	if type == "charged":
		current_bullet.damage = 20
		current_bullet.speed = 400
		current_bullet.scale *= 1.75
	elif type == "normal":
		current_bullet.damage = 15
		current_bullet.speed = 600
	current_bullet.global_position = bullet_spawn.global_position
	current_bullet.global_rotation = global_rotation
	get_tree().current_scene.add_child(current_bullet)
