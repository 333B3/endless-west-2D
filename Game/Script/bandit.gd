extends CharacterBody2D

var speed = 100
var direction = Vector2.ZERO
var change_direction = 1.0
var timer = 1.0
var stop_timer = 1.0
var is_stopped = false

func _ready():
	randomize()

func _process(_delta):
	timer -= _delta
	if timer <= 0:
		if is_stopped:
			direction = random_direction()
			timer = change_direction
			is_stopped = false
		else:
			direction = Vector2.ZERO
			timer = stop_timer
			is_stopped = true

	velocity = direction * speed
	move_and_slide()
	play_animation()

func random_direction() -> Vector2:
	var x = randi() % 3 - 1
	var y = randi() % 3 - 1
	var new_direction = Vector2(x, y).normalized()
	if new_direction != Vector2.ZERO:
		return new_direction
	else:
		return random_direction()

func play_animation():
	if is_stopped:
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("run")
