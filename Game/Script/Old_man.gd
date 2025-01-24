extends CharacterBody2D
var walk_speed = 150
func _ready():
	pass
	
func _process(delta):
	var movement = movement_vector()
	var direction = movement.normalized()
	velocity = walk_speed * direction

	if movement == Vector2.ZERO:
		$AnimatedSprite2D.play("Idle")
	if movement == Vector2(1,0):
		$AnimatedSprite2D.play("walk_right")
	if movement == Vector2(-1,0):
		$AnimatedSprite2D.play("walk_left")
	if Input.get_action_strength("Smoke"):
		$AnimatedSprite2D.play("Smoke")
	

	move_and_slide()

func movement_vector():
	var movement_x = Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")
	var movement_y = Input.get_action_strength("walk_down") - Input.get_action_strength("walk_up")
	return Vector2(movement_x, movement_y)
