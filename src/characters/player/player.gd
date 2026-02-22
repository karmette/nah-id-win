extends CharacterBody2D
@onready var cheese: AnimatedSprite2D = $Cheese
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var invinciblity_timer: Timer = $InvinciblityTimer
@onready var over_vfx: AnimationPlayer = $OverVFX
@onready var label: Label = $Label

@export var speed = 400
var health = 100
var dash_velocity: Vector2 = Vector2.ZERO
var decay = 2000
var dash_force = 1

@export var can_move = true
@export var invincible = false

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_just_pressed("dash"):
		dash(velocity.normalized(), 1000)
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
	SignalBus.shake_camera.emit(130, 0.2)
	invinciblity_timer.start()
	over_vfx.play.call_deferred("invincible_anim")

func take_damage(amount: int):
	health -= amount
	label.text = "Health: " + str(health)
	SignalBus.set_health.emit(health-amount)
