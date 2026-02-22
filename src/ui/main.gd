extends Control


func _on_play_button_pressed() -> void:
	SceneManager.goto_scene(Constants.SCENES.cutscene_one)
