extends KinematicBody2D


export var WANDER_SPEED = 10
export var DISTANCE_SPEED = 20
export var CHASE_SPEED = 20
export var ORBIT_SPEED = 15
export var MOVE_TIME = 2.0
export var WAIT_TIME = 1.0
export var ATTACK_INTERVAL = 3.0
export var FIREBALL_SPEED = 50

enum states {
	MOVE,
	WAIT,
	ORBIT,
	DISTANCE,
	CHASE
}
var state = states.WAIT
var velocity = Vector2()
var playerBody = null

onready var stateTimer = $StateTimer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hurtbox = $Hurtbox
onready var stats = $Stats
onready var attackTimer = $AttackTimer
onready var fireballSpawner = $FireballSpawner

const EnemyDeathEffect = preload("res://scenes/EnemyDeathEffect.tscn")

func _ready():
	randomize()
	state = states.WAIT
	stateTimer.start(WAIT_TIME)

func randomize_direction():
	velocity.x = (randi() % 20) - 10
	velocity.y = (randi() % 20) - 10
	velocity = velocity.normalized() * WANDER_SPEED

func _on_StateTimer_timeout():
	delta_func()

func update_animation_blend():
	var vector = velocity.normalized()
	animationTree.set("parameters/Idle/blend_position", vector)
	animationTree.set("parameters/Move/blend_position", vector)

# called when state timer is up
func delta_func():
	match state:
		states.WAIT:
			randomize_direction()
			update_animation_blend()
			animationState.travel("Move")
			state = states.MOVE
			stateTimer.start(MOVE_TIME)
		states.MOVE:
			continue
		_:
			velocity = Vector2.ZERO
			animationState.travel("Idle")
			state = states.WAIT
			stateTimer.start(WAIT_TIME)

func orbit():
	if playerBody != null:
		velocity = global_position.direction_to(playerBody.global_position).tangent() * ORBIT_SPEED
		animationState.travel("Move")


func _physics_process(_delta):
	match state:
		states.ORBIT:
			orbit()
			update_animation_blend()
		states.DISTANCE:
			orbit()
			if playerBody != null:
				velocity += playerBody.global_position.direction_to(global_position) * DISTANCE_SPEED
				update_animation_blend()
		states.CHASE:
			orbit()
			if playerBody != null:
				velocity += global_position.direction_to(playerBody.global_position) * CHASE_SPEED
				update_animation_blend()
	var _collision = move_and_slide(velocity)

func _on_Hurtbox_area_entered(area):
	hurtbox.start_invincibility(0.5)
	stats.health -= area.damage

func _on_Stats_no_health():
	queue_free()
	var deathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(deathEffect)
	deathEffect.position = position

func _on_DistanceZone_body_entered(_body):
	state = states.DISTANCE

func _on_DistanceZone_body_exited(_body):
	state = states.ORBIT

func _on_OrbitZone_body_entered(_body):
	state = states.ORBIT
	stateTimer.stop()

func _on_OrbitZone_body_exited(_body):
	state = states.CHASE

func _on_ChaseZone_body_entered(body):
	playerBody = body
	state = states.CHASE
	attackTimer.start(ATTACK_INTERVAL)
	stateTimer.stop()

func _on_ChaseZone_body_exited(_body):
	playerBody = null
	attackTimer.stop()
	delta_func()

func _on_AttackTimer_timeout():
	if playerBody != null:
		fireballSpawner.spawn(global_position.direction_to(playerBody.global_position), FIREBALL_SPEED)
