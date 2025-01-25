extends CharacterBody2D

var walk_speed = 150
var run_speed = 300
var last_direction: String = "down" 

func _ready():
	pass

func _process(delta):
	var movement = movement_vector()
	var direction = movement.normalized()
	var current_speed = walk_speed

	# ПРОВЕРКА КНОПКИ ШИФТ
	if Input.is_action_pressed("run"):
		current_speed = run_speed

	velocity = current_speed * direction

	# Если есть движение значит проигрываем анимацию бега или шага
	if movement != Vector2.ZERO:
		if movement == Vector2(1, 0):
			last_direction = "right"
			if current_speed == run_speed:
				$AnimatedSprite2D.play("run_right")
			else:
				$AnimatedSprite2D.play("walk_right")
		elif movement == Vector2(-1, 0):
			last_direction = "left"
			if current_speed == run_speed:
				$AnimatedSprite2D.play("run_left")
			else:
				$AnimatedSprite2D.play("walk_left")
		elif movement == Vector2(0, -1):
			last_direction = "up"
			if current_speed == run_speed:
				$AnimatedSprite2D.play("run_up")
			else:
				$AnimatedSprite2D.play("walk_up")
		elif movement == Vector2(0, 1):
			last_direction = "down"
			if current_speed == run_speed:
				$AnimatedSprite2D.play("run_down")
			else:
				$AnimatedSprite2D.play("walk_down")
	else:
	# Idle анимация соответствует последнему положению игрока
		$AnimatedSprite2D.play("idle_" + last_direction)

	move_and_slide()

func movement_vector():
	var movement_x = Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")
	var movement_y = Input.get_action_strength("walk_down") - Input.get_action_strength("walk_up")
	return Vector2(movement_x, movement_y)
