extends KinematicBody2D

var velocity = Vector2()
const ACCELERATION = 300
const MAX_SPEED = 100
const FRICTION = 300

onready var animationPlayer = get_node("AnimationPlayer")

func _physics_process(delta):
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		
	if input:
		velocity = velocity.move_toward(input.normalized() * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)