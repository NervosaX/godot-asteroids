extends Node

var asteroid_scene = preload("res://scenes/asteroid.tscn")


func _ready():
	generate_asteroids()


func generate_asteroids():
	var viewport_size = get_viewport().size

	# TODO: Make sure they're not too near the player
	for i in 8:
		var asteroid: Asteroid = asteroid_scene.instantiate()
		add_child(asteroid)
		asteroid.global_position = Vector2(
			randf_range(0, viewport_size.x), randf_range(0, viewport_size.y)
		)

		var rotation = deg_to_rad(randi_range(0, 360))
		asteroid.rotation = rotation
		asteroid.direction = Vector2.from_angle(rotation).normalized()

		asteroid.hit.connect(Callable(_on_asteroid_hit.bind(asteroid)))


func create_child_asteroid(parent: Asteroid):
	var new_asteroid: Asteroid = asteroid_scene.instantiate()
	add_child(new_asteroid)
	new_asteroid.global_position = parent.global_position
	var extra_rotation = deg_to_rad(randf_range(-50, 50))
	new_asteroid.rotation = parent.rotation + extra_rotation
	new_asteroid.direction = parent.direction.rotated(extra_rotation)
	new_asteroid.scale = parent.scale / 1.5
	new_asteroid.level = parent.level + 1
	new_asteroid.velocity_component.speed = 4 + (new_asteroid.level ** 0.5) * 1
	new_asteroid.hit.connect(Callable(_on_asteroid_hit.bind(new_asteroid)))


func _on_asteroid_hit(asteroid: Asteroid):
	if asteroid.level < 3:
		for i in 2:
			Callable(create_child_asteroid).call_deferred(asteroid)

	asteroid.queue_free()
