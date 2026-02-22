extends Node

var on_weapon_cooldown: bool = false
var cd_timer: float = 0
var unlocked_weapons = []
var max_health = 100
var current_dash = 300

func _process(delta: float) -> void:
	if cd_timer >= 0.5:
		on_weapon_cooldown = false
	if on_weapon_cooldown:
		cd_timer += delta
	if current_dash < 300:
		current_dash += .1
		SignalBus.update_stamina.emit()
