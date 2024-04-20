extends CharacterBody2D

@onready var screensize = get_viewport_rect().size

var speed = 700
var rotation_speed = 6
var is_dead = false


func _ready():
	respawn()


func _physics_process(delta):
	var move_input = Input.get_action_strength("thrust")
	var rotation_direction = Input.get_axis("rotate_left", "rotate_right")
	var target_velocity = (transform.x * move_input * speed).rotated(deg_to_rad(270))

	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * 0.5))

	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()


func _on_shoot_timer_timeout():
	if is_dead or not Input.get_action_strength("shoot"):
		return
		
	var bullet_scene = load("res://scenes/bullet.tscn")
	var bullet = bullet_scene.instantiate()
	
	get_parent().add_child(bullet)
	
	var direction = Vector2.RIGHT.rotated(rotation + deg_to_rad(-90)).normalized()
	bullet.global_position = global_position + direction * 25
	bullet.direction = direction


func _on_area_2d_area_entered(area: Area2D):
	var node = area.get_parent()
	if is_dead or not node is Asteroid:
		return
		
	node.queue_free()
	
	is_dead = true
	$AnimationPlayer.play("death")
	

func is_unsafe(enemies: Array[Node], unsafe_distance: int):
	"""
	Is the player currently in an unsafe area (ie, close to any enemies).
	"""
	for enemy in enemies:
		var distance = enemy.global_position.distance_to(global_position)
		if distance < unsafe_distance:
			return true
	return false


func find_safe_spot():
	"""
	Finds a safe place for the player to be based on the distance from enemies.
	Will attempt to spiral out from the middle searching for a safe position until
	one is found.
	
	Use await on this function.
	"""
	
	var deg = 0
	var distance = 0
	var unsafe_distance = 300
	var viewport_size = get_viewport().size
	
	var base_position = Vector2(viewport_size.x  / 2, viewport_size.y / 2)
	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemy")
	
	global_position = base_position
	
	while is_unsafe(enemies, unsafe_distance):
		# Prevent it KOing the CPU
		await get_tree().create_timer(0.001).timeout	

		var angle_radians = deg_to_rad(deg)
		var direction = Vector2(cos(angle_radians), sin(angle_radians))
		global_position = base_position + direction * distance
		deg += 40
		if distance > 500:
			distance = 0
		if deg > 360:
			deg = 0
			distance += 40


func respawn():
	velocity = Vector2.ZERO
	await find_safe_spot()
	$AnimationPlayer.play("RESET")
	is_dead = false
