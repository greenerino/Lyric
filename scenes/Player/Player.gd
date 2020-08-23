extends KinematicBody2D

var velocity = Vector2()
var direction = Vector2()
export var ACCELERATION = 300
export var MAX_SPEED = 100
export var FRICTION = 300
var stats = PlayerStats

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
onready var hurtBox = $Hurtbox
onready var blinkAnim = $BlinkAnimationPlayer

var DeathEffect = preload("res://scenes/effects/EnemyDeathEffect.tscn")

func _ready():
	stats.connect("no_health", self, "die")
	animationTree.active = true
	attackHitBox.knockback_vector = direction

func die():
	var effect = DeathEffect.instance()
	get_parent().add_child(effect)
	effect.global_position = global_position
	queue_free()

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

func _on_Hurtbox_area_entered(area):
	hurtBox.start_invincibility(0.5)
	stats.health -= area.damage

func _on_Hurtbox_invincibility_started():
	blinkAnim.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinkAnim.play("Stop")
