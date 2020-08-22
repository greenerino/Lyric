extends KinematicBody2D

export var direction = Vector2.ZERO
export var speed = 0

onready var spawnSoundPlayer = $SoundSpawn
const FireHit = preload("res://scenes/FireHit.tscn")

func _ready():
	spawnSoundPlayer.play()
	rotate(Vector2.RIGHT.angle_to(direction))


func _physics_process(delta):
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		destroy()

func destroy():
	var fireHit = FireHit.instance()
	get_parent().add_child(fireHit)
	fireHit.global_position = global_position
	queue_free()

func _on_Hitbox_area_entered(_area):
	destroy()