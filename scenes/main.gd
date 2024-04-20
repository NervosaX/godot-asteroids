extends Node2D

var life_container_scene = preload("res://ui/life_container.tscn")


func _ready():
	set_lives(Game.lives)
	set_score(Game.score)
	
	
func set_score(score: int):
	%Score.text = str(score).pad_zeros(7)


func set_lives(num_lives: int):
	var lives_container = %LivesContainer
	
	for child in lives_container.get_children():
		child.queue_free()
		
	for _i in num_lives:
		var container = life_container_scene.instantiate()
		lives_container.add_child(container)
