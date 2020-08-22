extends Node2D

const Fireball = preload("res://scenes/Fireball.tscn")

func spawn(direction, speed):
	var fireball = Fireball.instance()
	fireball.direction = direction
	fireball.speed = speed
	fireball.global_position = global_position
	get_tree().get_root().add_child(fireball)
