extends Rat

@export var exploding = false

func _physics_process(delta):
	if player == null:
		return
	if position.distance_to(player.position) < 5:
		near_player.emit()
	# Apply knockback first
	if knockback_velocity.length() > 0 and can_move:
		velocity = knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	elif can_move:
		# Normal movement logic here 
		var steering := Vector2.ZERO
		if not animation_player.is_playing() and not exploding:
			animation_player.play("walking")
		steering += seek() * seek_weight
		steering += avoid_obstacles() * avoid_weight
		steering += separation() * separation_weight
		steering += alignment() * alignment_weight
		steering += cohesion() * cohesion_weight
		
		steering = steering.limit_length(max_force)
		
		velocity += steering * delta
		velocity = velocity.limit_length(max_speed)
		steering += Vector2(randf_range(-50, 50), randf_range(-50, 50)) * 0.1
	move_and_slide()

func seek() -> Vector2:
	var to_player = player.global_position - global_position
	var distance = to_player.length()
	
	if distance <= 90:
		animation_player.play("explode")
		return Vector2.ZERO
	
	var desired_speed = max_speed
	
	# Slow down when close to player (arrival behavior)
	var slow_radius = 50.0
	if distance < slow_radius:
		desired_speed = max_speed * (distance / slow_radius)
	
	var desired_velocity = to_player.normalized() * desired_speed
	
	# Flip sprite
	if desired_velocity.x < 0:
		sprite_2d.flip_h = true
	elif desired_velocity.x > 0:
		sprite_2d.flip_h = false
		
	return desired_velocity - velocity
	
func die():
	var random = RandomNumberGenerator.new()
	var chance = random.randi()%10
	if chance == 0:
		var pickup = Constants.PICKUP.instantiate()
		pickup.pickup_r = Constants.PICKUPS.milk
		SceneManager.current_scene.add_child.call_deferred(pickup)
		pickup.position = self.position
	animation_player.play("take_damage")
	await animation_player.animation_finished
	self.queue_free()

func take_damage(amount: int, direction: Vector2, force):
	sfx_damaged.pitch_scale = randf_range(0.8, 1.2)
	sfx_damaged.volume_db = randf_range(-10, -8)
	sfx_squeak.pitch_scale = randf_range(0.8, 1.2)
	sfx_squeak.volume_db = randf_range(-10, -8)
	hit_particles.rotation = direction.angle()
	hit_particles.restart()
	take_knockback(direction, force)
	
	if not exploding:
		self.get_node("AnimationPlayer").play("take_damage")
		
	health -= amount
	if health <= 0:
		die()

func _init():
	damage = 15
	health = 15
	seek_weight = 2.0
	knockback_decay = 500
	max_speed = 400
	max_force = 1800
	separation_weight = 4.5
	cohesion_weight = 0.3
