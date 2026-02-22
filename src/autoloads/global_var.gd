extends Node

var on_weapon_cooldown: bool = false
var cd_timer: float = 0

func _process(delta: float) -> void:
	if cd_timer >= 0.5:
		on_weapon_cooldown = false
	if GlobalVar.on_weapon_cooldown:
		cd_timer += delta