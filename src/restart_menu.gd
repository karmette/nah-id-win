extends Node2D

@onready var restart: Button = $CanvasLayer/Restart


func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")
