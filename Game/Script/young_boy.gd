extends CharacterBody2D
var walk_speed = 150
var run_speed = 300

func _ready():
	pass

func _process(delta):
	var movement = movement_vector()
	var direction = movement.normalized()
	var current_speed = walk_speed
	if Input.is_action_pressed("run"):
		current_speed = run_speed

	velocity = current_speed * direction

	if movement == Vector2.ZERO:
		$AnimatedSprite2D.play("idle")
	elif current_speed == run_speed:  
		if movement == Vector2(1, 0):
			$AnimatedSprite2D.play("run_right")
		elif movement == Vector2(-1, 0):
			$AnimatedSprite2D.play("run_left")
		elif movement == Vector2(0, -1):
			$AnimatedSprite2D.play("run_up")
		elif movement == Vector2(0, 1):
			$AnimatedSprite2D.play("run_down")

	if current_speed == walk_speed:  
		if movement == Vector2(1, 0):
			$AnimatedSprite2D.play("walk_right")
		elif movement == Vector2(-1, 0):
			$AnimatedSprite2D.play("walk_left")
		elif movement == Vector2(0, -1):
			$AnimatedSprite2D.play("walk_up")
		elif movement == Vector2(0, 1):
			$AnimatedSprite2D.play("walk_down")

	move_and_slide()

func movement_vector():
	var movement_x = Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")
	var movement_y = Input.get_action_strength("walk_down") - Input.get_action_strength("walk_up")
	return Vector2(movement_x, movement_y)
