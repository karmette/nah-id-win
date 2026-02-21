extends Node2D
@export var ring_radius: float = 200.0

func begin_wave(rate: float, scale: float, easy: bool = true):
	var enemy_count: int = rate*10
	var angle_step: float = (2 * PI) / enemy_count

	for i in range(enemy_count):
		var current_angle: float = angle_step * i
		var spawn_position = Vector2.RIGHT.rotated(current_angle) * ring_radius
		
		# Instantiate the enemy
		#var enemy = enemy_scene.instantiate()
		#add_child(enemy)
		#enemy.position = spawn_position
	
