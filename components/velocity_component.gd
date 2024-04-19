class_name VelocityComponent
extends Node

@export var speed: int = 10
@export var node: Node2D

func move(direction: Vector2):
	node.global_position += direction * speed
	
