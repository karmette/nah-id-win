extends Node2D

@onready var animation_player: AnimationPlayer = $ForkSprite/AnimationPlayer
@onready var fork_sprite: Sprite2D = $ForkSprite
#@onready var charge_length: Timer = $ChargeLength
@onready var swing_sfx: AudioStreamPlayer2D = $swing_sfx

var on_cooldown = false

var swing_damage = 5

var thrust_damage_max = 25
var thrust_damage_min = 4

var player: Node2D

var thrust_dash_force_max = 1250
var thrust_dash_force_min = 500

var thrust_knockback_force_max = 750
var thrust_knockback_force_min = 250
var thrust_recoil_force = 150

var swing_knockback_force = 400
var swing_recoil_force = 300

var decay = 2000

var charge = 0
var charging = false
var active = false

func _ready():
	SignalBus.toggle_attacking.connect(_on_attacking_toggled)
	SignalBus.changed_weapon_to.connect(_on_active_toggled)
	player = get_tree().get_first_node_in_group("player")

func _on_attacking_toggled(state: bool):
	on_cooldown = state
	
func _on_active_toggled(weapon: String):
	if weapon == "fork":
		active = true
		self.visible = true
		animation_player.play("picked")
	else:
		active = false
		self.visible = false

func _input(event):
	if active:
		if Input.is_action_just_pressed("swing") and not on_cooldown:
			swing_sfx.pitch_scale = randf_range(0.8, 1.2)
			swing_sfx.volume_db = randf_range(-22, -20)
			animation_player.play("swing")
			
			
		if Input.is_action_just_pressed("thrust") and not on_cooldown:
			swing_sfx.pitch_scale = randf_range(0.8, 1.2)
			swing_sfx.volume_db = randf_range(-22, -20)
			animation_player.play("charge_thrust")
			charging = true

		if Input.is_action_just_released("thrust") and not on_cooldown:
			if charging:
				thrust()

func thrust():
	charging = false
	determine_charge_value()
	var thrust_force = lerp(thrust_dash_force_min, thrust_dash_force_max, charge)
	player.dash((get_global_mouse_position() - global_position).normalized(), thrust_force)
	animation_player.play("thrust")

#Signals
func emit_attacking(state: bool):
	SignalBus.toggle_attacking.emit(state)
	
func _on_hitbox_area_entered(area: Area2D) -> void:
	SignalBus.shake_camera.emit(30, 0.2)
	var enemy = area.get_parent()
	var direction = (enemy.global_position - global_position).normalized()

	if animation_player.current_animation == "thrust":
		var knockback_force = lerp(thrust_knockback_force_min, thrust_knockback_force_max, charge)
		var damage = lerp(thrust_damage_min, thrust_damage_max, charge)
		enemy.take_damage(damage, direction, knockback_force)
		player.dash((-(get_global_mouse_position() - global_position)).normalized(), thrust_recoil_force)
	elif animation_player.current_animation == "swing":
		enemy.take_damage(swing_damage, direction, swing_knockback_force)
		player.dash((-(get_global_mouse_position() - global_position)).normalized(), swing_recoil_force)

func determine_charge_value():
	charge = animation_player.current_animation_position / 2

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "charge_thrust":
		thrust()
