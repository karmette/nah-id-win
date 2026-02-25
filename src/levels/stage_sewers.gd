extends Node2D

@onready var central_light: PointLight2D = $CentralLight
@onready var canvas_modulate: CanvasModulate = $CanvasModulate

func _ready():
	SignalBus.toggle_spotlight.connect(_on_spotlight_toggled)

func _on_spotlight_toggled(on: bool):
	if on:
		central_light.show()
		canvas_modulate.show()
	else:
		central_light.hide()
		canvas_modulate.hide()
