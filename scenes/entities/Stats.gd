extends Node

export var max_health = 1
onready var health = max_health setget set_health

signal no_health
signal health_changed(val)

func set_health(val):
	health = val
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
