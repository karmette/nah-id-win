extends CharacterBody2D

@export var speed: float = 150.0
@export var steer_force: float = 600.0
@export var avoid_force: float = 900.0
@export var look_ahead: float = 60.0
var player: Node2D

@onready var forward_ray: RayCast2D = $ForwardRay


func _ready():
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta):
	if not player:
		return

	var steering = Vector2.ZERO

	# SEEK FORCE
	steering += seek()

	# OBSTACLE AVOIDANCE
	steering += avoid_obstacles()

	# Apply steering
	velocity += steering * delta
	velocity = velocity.limit_length(speed)

	move_and_slide()
	

func seek() -> Vector2:
	var desired_velocity = (player.global_position - global_position).normalized() * speed
	return (desired_velocity - velocity).limit_length(steer_force)


func avoid_obstacles() -> Vector2:
	forward_ray.target_position = velocity.normalized() * look_ahead
	
	if forward_ray.is_colliding():
		var normal = forward_ray.get_collision_normal()
		return normal * avoid_force
	
	return Vector2.ZERO
