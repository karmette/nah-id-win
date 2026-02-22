extends Node2D

@onready var animation_player: AnimationPlayer = $AnimatedSprite2D/AnimationPlayer
const BULLET = preload("res://cheese_bullet.tscn")
@onready var bullet_spawn: Marker2D = $AnimatedSprite2D/BulletSpawn

var active = false
var on_cooldown = false
var player: Node2D

var shot_normal_recoil_force = 500

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
	
func recoil_player():
	player.dash(-(global_transform.x.normalized()), shot_normal_recoil_force)
	
func toggle_player_movement(able_to_move: bool):
	player.can_move = able_to_move
	if not able_to_move:
		player.velocity = Vector2.ZERO
	

func _input(event):
	if active:
		if Input.is_action_just_pressed("shoot") and not on_cooldown:
			animation_player.play("shoot")

func spawn_bullet():
	var bullet = BULLET.instantiate()
	bullet.global_position = bullet_spawn.global_position
	bullet.global_rotation = global_rotation
	get_tree().current_scene.add_child(bullet)
