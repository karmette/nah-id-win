extends TextureRect

@onready var health_bar: TextureProgressBar = $HealthBar
@onready var stamina_bar: TextureProgressBar = $HealthBar/StaminaBar

@onready var under_bar: TextureProgressBar = $UnderBar

func _ready() -> void:
	SignalBus.set_health.connect(change_health)
	SignalBus.update_stamina.connect(change_stamina)
	change_stamina()

func change_health(value: int):
	var tween = create_tween()
	var new_value = value
	tween.tween_property(health_bar, "value", new_value, 0.1)
	await get_tree().create_timer(0.3).timeout
	tween = create_tween()
	tween.tween_property(under_bar, "value", new_value, 0.1)
	
func change_stamina():
	stamina_bar.value = GlobalVar.current_dash
	
