extends Node2D
@export var ring_radius: float = 250.0

var current_level: Node2D

func _ready() -> void:
	match GameManager.current_level:
		0:
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
	begin_wave(2, 1, true, true)

func begin_wave(rate: float = 1.0, stat_scale: float = 1.0, basic: bool = true, fast: bool = false):
	var enemy_count: int = int(rate*5)
	var angle_step: float = (2 * PI) / enemy_count

	for i in range(enemy_count):
		var current_angle: float = angle_step * i
		var spawn_position = Vector2.RIGHT.rotated(current_angle) * ring_radius
		
		# Instantiate the enemy
		var allowed: Dictionary[String, PackedScene]
		for key in Constants.ENEMIES:
			if basic:
				allowed[key] = Constants.ENEMIES[key]
			if fast:
				allowed[key] = Constants.ENEMIES[key]
		var enemy_name: String = allowed.keys().pick_random()
		var enemy_scene: PackedScene = allowed[enemy_name]
		var enemy: Node2D = enemy_scene.instantiate()
		enemy.global_position = global_position + spawn_position
		enemy.scale *= 2.075
		enemy.health *= stat_scale
		add_child(enemy)
