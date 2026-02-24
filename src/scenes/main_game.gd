extends Node2D
@export var ring_radius: float = 250.0

var current_level: Node2D

signal enemies_died

func _ready() -> void:
	match GameManager.current_level:
		0:
			load_level("sewers")
		1:
			load_level("sewers2")

func load_level(level_name: String):
	if not Constants.LEVELS.has(level_name):
		push_error("Invalid level: %s" % level_name)
		return
	if is_instance_valid(current_level):
		current_level.queue_free()
	var scene: PackedScene = Constants.LEVELS[level_name]
	current_level = scene.instantiate()   # this is a Node
	add_child(current_level)
	if level_name == "sewers":
		level_1()
	elif level_name == "sewers2":
		level_2()

func level_1():
	SignalBus.toggle_spotlight.emit(true)
	var pickup = Constants.PICKUP.instantiate()
	pickup.pickup_r = Constants.PICKUPS.fork
	SceneManager.current_scene.add_child.call_deferred(pickup)
	pickup.position = Vector2(0,0)
	await SignalBus.pickup_item
	SignalBus.toggle_spotlight.emit(false)
	SignalBus.changed_weapon_to.emit("fork")
	SignalBus.play_music.emit("start")
	for i in range(5):
		begin_wave.call_deferred(1, 1, true, true)
		await enemies_died
		await get_tree().create_timer(2).timeout
	SignalBus.fade.emit()
	await get_tree().create_timer(3).timeout
	GameManager.next_level()
	SceneManager.goto_scene(Constants.SCENES.cutscene_one)

func level_2():
	var pickup = Constants.PICKUP.instantiate()
	pickup.pickup_r = Constants.PICKUPS.blue_cheese
	SceneManager.current_scene.add_child.call_deferred(pickup)
	pickup.position = Vector2(0,0)
	await SignalBus.pickup_item
	for i in range(5):
		begin_wave.call_deferred(4, 2, true, true, true)
		await enemies_died
		await get_tree().create_timer(2).timeout
	SignalBus.fade.emit()
	await get_tree().create_timer(3).timeout
	GameManager.next_level()
	SceneManager.goto_scene(Constants.SCENES.cutscene_one)


func begin_wave(rate: float = 1.0, stat_scale: float = 1.0, basic: bool = true, fast: bool = false, explode: bool = false):
	var enemy_count: int = int(rate*5)
	var angle_step: float = (2 * PI) / enemy_count

	for i in range(enemy_count):
		var current_angle: float = angle_step * i
		var spawn_position = Vector2.RIGHT.rotated(current_angle) * ring_radius
		
		# Instantiate the enemy
		var allowed: Dictionary[String, PackedScene]
		for key in Constants.ENEMIES:
			if basic and key == "basic_rat":
				allowed[key] = Constants.ENEMIES[key]
			if fast and key == "fast_rat":
				allowed[key] = Constants.ENEMIES[key]
			if explode and key == "bomb_rat":
				allowed[key] = Constants.ENEMIES[key]
		var enemy_name: String = allowed.keys().pick_random()
		var enemy_scene: PackedScene = allowed[enemy_name]
		var enemy: Node2D = enemy_scene.instantiate()
		enemy.global_position = global_position + spawn_position
		enemy.scale *= 2.075
		enemy.health *= stat_scale
		add_child(enemy)

func _process(delta: float) -> void:
	if get_tree().get_nodes_in_group("enemies").is_empty():
		enemies_died.emit()
