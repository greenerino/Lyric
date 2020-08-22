extends Node2D

onready var particles = $Particles

func _ready():
	particles.emitting = true

func _on_Sound_finished():
	queue_free()
