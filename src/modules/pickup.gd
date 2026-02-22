extends Node2D

@export var pickup_r: PickupItem

@onready var sprite: Sprite2D = $ItemSprite

func _ready() -> void:
	sprite.texture = pickup_r.texture
	self.name = "Pickup" + pickup_r.item_name.capitalize()



func _on_pickup_range_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Player":
		# SignalBus.pickup_item.emit(pickup_r.item_name)
		if pickup_r.type == "weapon":
			GlobalVar.unlocked_weapons.append(pickup_r.item_name)
			SignalBus.pickup_item.emit(pickup_r.item_name)
		self.queue_free()
