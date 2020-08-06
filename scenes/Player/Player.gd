extends KinematicBody2D

var velocity = Vector2()
var direction = Vector2()
export var ACCELERATION = 300
export var MAX_SPEED = 100
export var FRICTION = 300

enum {
	MOVE,
	ATTACK
}
var state = MOVE

# onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var attackAnim = $Attack
onready var attackHitBox = $Attack/Hitbox

func _ready():
	animationTree.active = true
	attackHitBox.knockback_vector = direction

func attack():
	velocity = Vector2.ZERO
	attackAnim.attack(direction)
	animationState.travel("Attack")

func attack_finished():
	state = MOVE

func _physics_process(delta):
	match state:
		MOVE:
			move(delta)
		ATTACK:
			attack()

func move(delta):
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		
	if input:
		direction = input
		attackHitBox.knockback_vector = direction
		animationTree.set("parameters/Idle/blend_position", input)
		animationTree.set("parameters/Run/blend_position", input)
		animationTree.set("parameters/Attack/blend_position", input)
		animationState.travel("Run")
		velocity = velocity.move_toward(input.normalized() * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)

	if Input.is_action_just_pressed("attack"):
		state = ATTACK
