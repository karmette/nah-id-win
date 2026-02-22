extends Control


func _on_play_button_pressed() -> void:
	SceneManager.goto_scene(Constants.SCENES.cutscene_one)


func _on_play_button_4_pressed() -> void:
	get_tree().quit()
