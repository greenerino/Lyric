extends Node2D

onready var attackAnimTree = $AnimationTree
onready var attackAnimState = attackAnimTree.get("parameters/playback")

func attack(direction):
	attackAnimTree.set("parameters/Attack/blend_position", direction)
	attackAnimState.travel("Attack")
