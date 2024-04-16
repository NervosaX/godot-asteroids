extends CharacterBody2D

@onready var screensize = get_viewport_rect().size

var speed = 800
var rotation_speed = 6

func _physics_process(delta):
	var move_input = Input.get_action_strength("thrust")
	var rotation_direction = Input.get_axis("rotate_left", "rotate_right")
	var target_velocity = (transform.x * move_input * speed).rotated(deg_to_rad(270))

	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * 0.5))

	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()
	
	global_position.x = wrapf(global_position.x, 0, screensize.x)
	global_position.y = wrapf(global_position.y, 0, screensize.y)
