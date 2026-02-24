extends CharacterBody2D
@onready var cheese: AnimatedSprite2D = $Cheese
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var invinciblity_timer: Timer = $InvinciblityTimer
@onready var over_vfx: AnimationPlayer = $OverVFX
@onready var label: Label = $Label
@onready var sfx_squish: AudioStreamPlayer2D = $AnimationPlayer/sfx_squish

@export var speed = 400
var health = 10
var dash_velocity: Vector2 = Vector2.ZERO
var decay = 2000
var dash_force = 1

@export var can_move = true
@export var invincible = false

func _ready() -> void:
	SignalBus.add_health.connect(heal)

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_just_pressed("dash"):
		if GlobalVar.current_dash >= 100:
			dash(velocity.normalized(), 1000)
			GlobalVar.current_dash -= 100
			SignalBus.update_stamina.emit()
			over_vfx.play("dash_anim")
	velocity = input_direction * speed

func dash(direction, force: int):
	dash_force = force
	dash_velocity = direction * dash_force #sets knockback

func _physics_process(delta):
	
	if dash_velocity.length() != 0:
		velocity = dash_velocity
		dash_velocity = dash_velocity.move_toward(Vector2.ZERO, decay * delta)
	else:
		# Normal movement logic here 
		if can_move:
			get_input()
		
	move_and_slide()
	
	if velocity.length() > 0:
		# Add your code here for when the character is moving (e.g., play walk animation)
		if animation_player.current_animation != "moving":
			animation_player.play("moving")
	else:
		# Add your code here for when the character is not moving (e.g., play idle animation)
		if animation_player.current_animation != "idle":
			animation_player.play("idle")


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if invincible:
		return
	
	var body = area.get_parent()
	
	invincible = true   # ← SET IT HERE IMMEDIATELY
	
	take_damage(body.damage)

func take_damage(amount: int):
	print(health)
	health -= amount
	SignalBus.set_health.emit(health-amount)
	if health <= 0:
		die()
	else:
		SignalBus.shake_camera.emit(130, 0.2)
		invinciblity_timer.start()
		over_vfx.play.call_deferred("invincible_anim")
		
	label.text = "Health: " + str(health)

func heal(amount: int):
	health += amount
	if health >= GlobalVar.max_health:
		health = 100
		SignalBus.set_health.emit(health)
		return
	SignalBus.set_health.emit(health+amount)
	
func vary_squish():
	sfx_squish.pitch_scale = randf_range(0.8, 1.2)
	sfx_squish.volume_db = randf_range(-16, -14)

func toggle_player_movement(able_to_move: bool):
	self.can_move = able_to_move
	if not able_to_move:
		self.velocity = Vector2.ZERO

func die():
	SignalBus.player_death_fade.emit()
	SignalBus.shake_camera.emit(130, 10)
	over_vfx.play("die")
	SignalBus.stop_song.emit()
	await over_vfx.animation_finished
	SceneManager.goto_scene("res://restart_menu.tscn")
	
