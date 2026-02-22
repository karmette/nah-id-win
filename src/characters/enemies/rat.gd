class_name Rat
extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var hit_particles: GPUParticles2D = $HitParticles

@export var health = 20
@export var knockback_force = 750
@export var knockback_decay = 800

var knockback_velocity: Vector2 = Vector2.ZERO

# ========================
# Movement tuning
# ========================

@export var max_speed: float = 140.0
@export var max_force: float = 900.0
@export var look_ahead: float = 60.0


# Flocking weights
@export var seek_weight: float = 0.8
@export var avoid_weight: float = 2.5
@export var separation_weight: float = 3.5   # Increase a lot
@export var alignment_weight: float = 0.4
@export var cohesion_weight: float = 0.3

# Flocking radii
@export var separation_radius: float = 35.0
@export var neighbor_radius: float = 80.0
var player: Node2D

@onready var forward_ray: RayCast2D = $ForwardRay
var damage = 5

func _ready():
	add_to_group("enemies")
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player == null:
		return

	# Apply knockback first
	if knockback_velocity.length() > 0:
		velocity = knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	else:
		# Normal movement logic here 
		if not sprite_2d.is_playing():
			sprite_2d.play()
		var steering := Vector2.ZERO
		
		steering += seek() * seek_weight
		steering += avoid_obstacles() * avoid_weight
		steering += separation() * separation_weight
		steering += alignment() * alignment_weight
		steering += cohesion() * cohesion_weight
		
		steering = steering.limit_length(max_force)
		
		velocity += steering * delta
		velocity = velocity.limit_length(max_speed)
		steering += Vector2(randf_range(-50, 50), randf_range(-50, 50)) * 0.1
	move_and_slide()

	# if velocity.length() > 5:
	# 	rotation = velocity.angle()


# ========================
# SEEK PLAYER
# ========================

func seek() -> Vector2:
	var to_player = player.global_position - global_position
	var distance = to_player.length()
	
	if distance == 0:
		return Vector2.ZERO
	
	var desired_speed = max_speed
	
	# Slow down when close to player (arrival behavior)
	var slow_radius = 50.0
	if distance < slow_radius:
		desired_speed = max_speed * (distance / slow_radius)
	
	var desired_velocity = to_player.normalized() * desired_speed
	
	# Flip sprite
	if desired_velocity.x < 0:
		sprite_2d.flip_h = false
	elif desired_velocity.x > 0:
		sprite_2d.flip_h = true
		
	return desired_velocity - velocity


# ========================
# OBSTACLE AVOIDANCE
# ========================

func avoid_obstacles() -> Vector2:
	var forward_dir = velocity
	if forward_dir.length() < 5:
		forward_dir = (player.global_position - global_position)

	forward_ray.target_position = forward_dir.normalized() * look_ahead

	if forward_ray.is_colliding():
		var normal = forward_ray.get_collision_normal()
		return normal * max_force

	return Vector2.ZERO


# ========================
# SEPARATION
# ========================

func separation() -> Vector2:
	var force := Vector2.ZERO
	var count := 0

	for other in get_tree().get_nodes_in_group("enemies"):
		if other == self:
			continue

		var dist = global_position.distance_to(other.global_position)
		if dist < separation_radius and dist > 0:
			var push = (global_position - other.global_position).normalized()
			
			# Stronger when closer
			push *= (separation_radius - dist) / separation_radius
			
			force += push
			count += 1

	if count > 0:
		force /= count
		force = force.normalized() * max_force

	return force


# ========================
# ALIGNMENT
# ========================

func alignment() -> Vector2:
	var avg_velocity := Vector2.ZERO
	var count := 0

	for other in get_tree().get_nodes_in_group("enemies"):
		if other == self:
			continue

		var dist = global_position.distance_to(other.global_position)
		if dist < neighbor_radius:
			avg_velocity += other.velocity
			count += 1

	if count > 0:
		avg_velocity /= count
		return (avg_velocity - velocity)

	return Vector2.ZERO


# ========================
# COHESION
# ========================

func cohesion() -> Vector2:
	var center := Vector2.ZERO
	var count := 0

	for other in get_tree().get_nodes_in_group("enemies"):
		if other == self:
			continue

		var dist = global_position.distance_to(other.global_position)
		if dist < neighbor_radius:
			center += other.global_position
			count += 1

	if count > 0:
		center /= count
		var desired = (center - global_position).normalized() * max_speed
		return desired - velocity
	return Vector2.ZERO

func take_damage(amount: int, direction: Vector2, force):
	hit_particles.rotation = direction.angle()
	hit_particles.restart()
	sprite_2d.pause()
	self.get_node("AnimationPlayer").play("take_damage")
	take_knockback(direction, force)
	health -= amount
	if health <= 0:
		die()
	
func take_knockback(direction: Vector2, force:int):
	knockback_velocity = direction * force #sets knockback
	
func die():
	self.queue_free()
