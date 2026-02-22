extends Node2D

@export var speed: int = 600
var knockback_force = 800
@export var damage = 15

func _process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_hitbox_area_entered(area: Area2D) -> void:
	var enemy = area.get_parent()
	var direction = (enemy.global_position - global_position).normalized()
	enemy.take_damage(damage, direction, knockback_force)
	self.queue_free()
	
	
