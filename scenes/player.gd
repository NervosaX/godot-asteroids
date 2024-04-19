extends CharacterBody2D

@onready var screensize = get_viewport_rect().size

var speed = 700
var rotation_speed = 6

func _physics_process(delta):
	var move_input = Input.get_action_strength("thrust")
	var rotation_direction = Input.get_axis("rotate_left", "rotate_right")
	var target_velocity = (transform.x * move_input * speed).rotated(deg_to_rad(270))

	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * 0.5))

	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()

func _on_shoot_timer_timeout():
	if not Input.get_action_strength("shoot"):
		return
		
	var bullet_scene = load("res://scenes/bullet.tscn")
	var bullet = bullet_scene.instantiate()
	
	get_parent().add_child(bullet)
	
	var direction = Vector2.RIGHT.rotated(rotation + deg_to_rad(-90)).normalized()
	bullet.global_position = global_position + direction * 25
	bullet.direction = direction
