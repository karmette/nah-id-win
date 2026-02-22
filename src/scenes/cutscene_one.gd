extends Control

func _ready() -> void:
	SignalBus.start_dialogue.emit.call_deferred("cutscene_one")
	# change background and such
	await SignalBus.cutscene_finished
	SceneManager.goto_scene(Constants.SCENES.main_game)