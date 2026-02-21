extends Control

var slot: PackedScene = preload("uid://hpt5itklu07h")

enum Weapon{FORK, KNIFE, BLUE_CHEESE}

var current_weapon: Weapon = Weapon.KNIFE

func add_weapon(weapon_name: String):
	if not Constants.WEAPONS.has(weapon_name):
		push_error("Invalid level: %s" % weapon_name)
		return
	var slot_node: TextureRect = slot.instantiate()

	self.add_child(slot_node)
	slot_node.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)

func switch_weapon(weapon: Weapon):
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select_1"): # TODO: add unlocked weapons code later
		switch_weapon(Weapon.KNIFE)
	elif event.is_action_pressed("select_2"):
		switch_weapon(Weapon.FORK) 
	elif event.is_action_pressed("select_3"):
		switch_weapon(Weapon.BLUE_CHEESE) 
