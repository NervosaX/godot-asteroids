extends Sprite2D

var direction = Vector2.ZERO
@onready var velocity_component: VelocityComponent = $VelocityComponent


func _physics_process(_delta):
	velocity_component.move(direction)


func _on_time_to_live_timeout():
	queue_free()
