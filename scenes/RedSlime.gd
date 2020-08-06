extends KinematicBody2D

const SPEED = 5
const KNOCKBACK_SPEED = 50
const KNOCKBACK_FRICTION = 1
const MOVE_TIME = 2.0
const WAIT_TIME = 1.0
const STUN_TIME = 1.5
enum {
	MOVE,
	WAIT,
	KNOCKED
}
var state = MOVE
var time_left = WAIT_TIME
var velocity = Vector2.ZERO

func _ready():
	randomize()

func randomize_direction():
	velocity.x = (randi() % 20) - 10
	velocity.y = (randi() % 20) - 10
	velocity = velocity.normalized() * SPEED

func _physics_process(delta):
	time_left -= delta
	match state:
		MOVE:
			velocity = move_and_slide(velocity)
			if time_left <= 0:
				time_left = WAIT_TIME
				state = WAIT
		WAIT:
			velocity = Vector2.ZERO
			if time_left <= 0:
				randomize_direction()
				time_left = MOVE_TIME
				state = MOVE
		KNOCKED:
			velocity = velocity.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION)
			velocity = move_and_slide(velocity)
			if time_left <= 0:
				randomize_direction()
				time_left = MOVE_TIME
				state = MOVE

			
func _on_Hurtbox_area_entered(area):
	state = KNOCKED
	time_left = STUN_TIME
	velocity = area.knockback_vector * KNOCKBACK_SPEED
	print("knocked")
