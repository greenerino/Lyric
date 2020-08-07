extends AnimatedSprite

func _ready():
	var err = connect("animation_finished", self, "_on_animation_finished")
	if err:
		print("Error connecting signal: ", err)
		queue_free()
	else:
		play()

func _on_animation_finished():
	queue_free()