extends Control

var slot: PackedScene = preload("uid://r5d6li3pssqi")
var fork_texture: Texture2D = preload("uid://dgop0rkdkfmt6")
var knife_texture: Texture2D = preload("uid://cev5gora74jq3")
var cheese_texture: Texture2D = preload("uid://c7alhccw35b46")

@onready var cd: Timer = $SwitchCooldown
var can_switch: bool = true


enum Weapon{FORK, BLUE_CHEESE}

var current_weapon: Weapon
var weapon_slots: Dictionary[Weapon, Control] = {}

func _ready() -> void:
	cd.timeout.connect(_on_cd_timeout)
	# fork
	weapon_slots[Weapon.FORK] = slot.instantiate()
	weapon_slots[Weapon.FORK].weapon_texture = fork_texture
	weapon_slots[Weapon.FORK].weapon = "fork"

	# cheese
	weapon_slots[Weapon.BLUE_CHEESE] = slot.instantiate()
	weapon_slots[Weapon.BLUE_CHEESE].weapon_texture = cheese_texture
	weapon_slots[Weapon.BLUE_CHEESE].weapon = "blue_cheese"

	var offset: int = 100
	for i in weapon_slots:
		var weapon: Control = weapon_slots.get(i)
		add_child(weapon)
		weapon.position = Vector2(100+offset, 900+(offset/10.0))
		offset += 100
		weapon.scale *= 2


# func add_weapon(weapon_name: String):
# 	if not Constants.WEAPONS.has(weapon_name):
# 		push_error("Invalid level: %s" % weapon_name)
# 		return
# 	var slot_node: TextureRect = slot.instantiate()

# 	self.add_child(slot_node)
# 	slot_node.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)

func switch_weapon(weapon: Weapon):
	for i in weapon_slots:
		if i != weapon:
			weapon_slots.get(i).selected = false
		else:
			weapon_slots.get(i).selected = true
	cd.start()
	can_switch = false
		
func _input(event: InputEvent) -> void:
	if can_switch:
		if event.is_action_pressed("select_1") and GlobalVar.unlocked_weapons.has("fork"):
			switch_weapon(Weapon.FORK)
			SignalBus.changed_weapon_to.emit("fork")
		elif event.is_action_pressed("select_2") and GlobalVar.unlocked_weapons.has("blue_cheese"):
			switch_weapon(Weapon.BLUE_CHEESE) 
			SignalBus.changed_weapon_to.emit("blue_cheese")

func _on_cd_timeout() -> void:
	can_switch = true
