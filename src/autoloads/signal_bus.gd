extends Node

signal start_dialogue(s: String) # pass dialogue name in constants

signal toggle_attacking(state: bool)

signal shake_camera(intensity: int, time: float)

signal pickup_item(item: String)

signal changed_weapon_to(weapon: String)
signal cutscene_finished()

signal set_mana(value: int)
signal set_health(value: int)