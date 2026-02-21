extends CharacterBody2D
@onready var cheese: AnimatedSprite2D = $Cheese
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var speed = 400
var health = 100

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed


func _physics_process(delta):
	get_input()
	move_and_slide()
	
	if velocity.length() > 0:
		# Add your code here for when the character is moving (e.g., play walk animation)
		if animation_player.current_animation != "moving":
			animation_player.play("moving")
	else:
		# Add your code here for when the character is not moving (e.g., play idle animation)
		if animation_player.current_animation != "idle":
			animation_player.play("idle")
