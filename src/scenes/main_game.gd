extends Node2D
@export var ring_radius: float = 200.0

var current_level: Node2D

func _ready() -> void:
	load_level("sewers")

func load_level(level_name: String):
	if not Constants.LEVELS.has(level_name):
		push_error("Invalid level: %s" % level_name)
		return
	if is_instance_valid(current_level):
		current_level.queue_free()
	var scene: PackedScene = Constants.LEVELS[level_name]
	current_level = scene.instantiate()   # this is a Node
	add_child(current_level)
	begin_wave()

func begin_wave(rate: float = 1.0, scale: float = 1.0, easy: bool = true):
	var enemy_count: int = rate*10
	var angle_step: float = (2 * PI) / enemy_count

	for i in range(enemy_count):
		var current_angle: float = angle_step * i
		var spawn_position = Vector2.RIGHT.rotated(current_angle) * ring_radius
		
		# Instantiate the enemy
		var enemy_name: String = Constants.ENEMIES_EASY.keys().pick_random()
		var enemy_scene: PackedScene = Constants.ENEMIES_EASY[enemy_name]
		var enemy: Node2D = enemy_scene.instantiate()
		enemy.global_position = global_position + spawn_position
		enemy.scale = Vector2(1.5, 1.5)
		add_child(enemy)
		#add_child(enemy)
		
		#enemy.position = spawn_position