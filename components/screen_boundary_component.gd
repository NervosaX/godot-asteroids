extends Node2D

@export var node2d: Node2D
@onready var screensize = get_viewport_rect().size


func _physics_process(_delta):
	node2d.global_position.x = wrapf(node2d.global_position.x, 0, screensize.x)
	node2d.global_position.y = wrapf(node2d.global_position.y, 0, screensize.y)
