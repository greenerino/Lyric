extends KinematicBody2D

onready var animPlayer = $AnimationPlayer

func _on_Hurtbox_area_entered(_area):
	animPlayer.play("Hit")