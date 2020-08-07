extends KinematicBody2D

onready var stats = $Stats

const EnemyDeathEffect = preload("res://scenes/EnemyDeathEffect.tscn")

const SPEED = 5
const KNOCKBACK_SPEED = 80
const KNOCKBACK_FRICTION = 4
const CHASE_SPEED = 20
const MOVE_TIME = 2.0
const WAIT_TIME = 1.0
const STUN_TIME = 0.8
enum {
	MOVE,
	WAIT,
	KNOCKED,
	CHASE
}
var state = MOVE
var time_left = WAIT_TIME
var velocity = Vector2.ZERO
var playerBody = null

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
				if playerBody == null:
					randomize_direction()
					time_left = MOVE_TIME
					state = MOVE
				else:
					state = CHASE
		CHASE:
			if playerBody == null:
				state = WAIT
				time_left = WAIT_TIME
			else:
				velocity = velocity.move_toward(position.direction_to(playerBody.position) * CHASE_SPEED, 100)
				velocity = move_and_slide(velocity)

			
func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	state = KNOCKED
	time_left = STUN_TIME
	velocity = area.knockback_vector * KNOCKBACK_SPEED


func _on_Stats_no_health():
	queue_free()
	var deathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(deathEffect)
	deathEffect.position = position

func _on_PlayerDetectionZone_body_entered(body):
	playerBody = body
	state = CHASE

func _on_PlayerDetectionZone_body_exited(_body):
	state = WAIT
	time_left = WAIT_TIME
