extends Node2D

func _on_restart_pressed() -> void:
	SceneManager.goto_scene(Constants.SCENES.main_game)
