extends Node2D

var active = false
var on_cooldown = false
var player: Node2D

func _ready():
	SignalBus.toggle_attacking.connect(_on_attacking_toggled)
	SignalBus.changed_weapon_to.connect(_on_active_toggled)
	player = get_tree().get_first_node_in_group("player")

func _on_attacking_toggled(state: bool):
	on_cooldown = state

func _on_active_toggled(weapon: String):
	if weapon == "blue_cheese":
		active = true
		self.visible = true
	else:
		active = false
		self.visible = false
		
func _input(event):
	if active:
		pass
