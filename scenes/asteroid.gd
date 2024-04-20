class_name Asteroid
extends Node2D

signal hit

@onready var velocity_component: VelocityComponent = $VelocityComponent

# 
const SCORE_VALUES = [20, 50, 100]

var direction = Vector2.ZERO
var rotation_step = 0
var unkillable = true
var level = 1


func process_hit():
	hit.emit()


func _ready():
	rotation_step = deg_to_rad(randf_range(-0.6, 0.6))


func _physics_process(_delta):
	velocity_component.move(direction)
	rotate(rotation_step)


func _on_area_2d_area_entered(area: Area2D):
	if unkillable or not area.get_tree().has_group("bullet"):
		return

	# Destroy the bullet
	area.get_parent().queue_free()
	
	process_hit()


func _on_safety_timer_timeout():
	unkillable = false
