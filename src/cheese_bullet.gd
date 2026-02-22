extends Node2D

const SPEED: int = 600

func _process(delta: float) -> void:
	position += transform.x * SPEED * delta
