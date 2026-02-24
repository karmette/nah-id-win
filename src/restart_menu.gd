extends Node2D

@onready var restart: Button = $CanvasLayer/Restart


func _on_restart_pressed() -> void:
	SceneManager.goto_scene(Constants.SCENES.cutscene_one)
