extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

@export var health = 15
@export var knockback_force = 300
@export var knockback_decay = 800


var knockback_velocity: Vector2 = Vector2.ZERO

# ========================
# Movement tuning
# ========================

@export var max_speed: float = 140.0
@export var max_force: float = 900.0
@export var look_ahead: float = 60.0


# Flocking weights
@export var seek_weight: float = 1.0
@export var avoid_weight: float = 2.0
@export var separation_weight: float = 1.8
@export var alignment_weight: float = 0.6
@export var cohesion_weight: float = 0.5

# Flocking radii
@export var separation_radius: float = 35.0
@export var neighbor_radius: float = 80.0
var player: Node2D

@onready var forward_ray: RayCast2D = $ForwardRay


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
		var steering := Vector2.ZERO
		
		steering += seek() * seek_weight
		steering += avoid_obstacles() * avoid_weight
		steering += separation() * separation_weight
		steering += alignment() * alignment_weight
		steering += cohesion() * cohesion_weight
		
		steering = steering.limit_length(max_force)
		
		velocity += steering * delta
		velocity = velocity.limit_length(max_speed)
		
	move_and_slide()

	# if velocity.length() > 5:
	# 	rotation = velocity.angle()


# ========================
# SEEK PLAYER
# ========================

func seek() -> Vector2:
	var desired = (player.global_position - global_position).normalized() * max_speed
	if desired.x < 0:
		sprite_2d.flip_h = false
	elif desired.x > 0:
		sprite_2d.flip_h = true
	return desired - velocity


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
			force += (global_position - other.global_position).normalized() / dist
			count += 1

	if count > 0:
		force /= count

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

func take_damage(amount: int, direction: Vector2):
	animation_player.play("take_damage")
	health -= amount
	knockback_velocity = direction * knockback_force #sets knockback
	print("ASDSA")
