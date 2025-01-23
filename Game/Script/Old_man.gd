extends CharacterBody2D
const SPEED = 300.0

func _physics_process(delta: float)-> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#if direction:
	velocity = direction * SPEED
	
	var animation := "Idle"
	if velocity:
		animation = "walk"
	
	$AnimatedSprite2D.play(animation)
	move_and_slide()
