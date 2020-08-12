extends Area2D

var invincible = false
onready var timer = $InvincibilityTimer
onready var HitEffect = preload("res://scenes/HitEffect.tscn")

signal invincibility_started
signal invincibility_ended

func create_hit_effect():
	var hitEffect = HitEffect.instance()
	get_parent().add_child(hitEffect)
	hitEffect.position = position

func _on_InvincibilityTimer_timeout():
	invincible = false
	emit_signal("invincibility_ended")
	timer.stop()

func start_invincibility(duration):
	invincible = true
	emit_signal("invincibility_started")
	timer.start(duration)

func _on_Hurtbox_invincibility_ended():
	monitoring = true

func _on_Hurtbox_invincibility_started():
	set_deferred("monitoring",  false)

func _on_Hurtbox_area_entered(_area):
	create_hit_effect()