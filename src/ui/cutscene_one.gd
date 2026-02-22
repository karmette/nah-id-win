extends Control

func _ready() -> void:
	SignalBus.start_dialogue.emit.call_deferred("cutscene_one")
	# change background and such