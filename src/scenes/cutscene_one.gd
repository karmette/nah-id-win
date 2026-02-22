extends Control

func _ready() -> void:
	match GameManager.current_level:
		0:
			SignalBus.start_dialogue.emit.call_deferred("cutscene_one")
			SignalBus.play_music.emit("journey")
		1:
			SignalBus.start_dialogue.emit.call_deferred("cutscene_two")
			SignalBus.play_music.emit("shimmer")
			# change background and such
		2: 
			SignalBus.start_dialogue.emit.call_deferred("cutscene_three")
	await SignalBus.cutscene_finished
	if GameManager.current_level == 2:
		get_tree().quit()
	SceneManager.goto_scene(Constants.SCENES.main_game)