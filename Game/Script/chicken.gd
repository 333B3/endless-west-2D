extends CharacterBody2D

var speed = 50
var change_direction = 1.2
var timer = 1.5
var stop_timer = 1.2
var is_stopped = false
var direction = Vector2.ZERO  # Глобальная переменная направления

func _ready():
	randomize()

func _physics_process(delta):
	timer -= delta
	if timer <= 0:
		if is_stopped:
			direction = random_direction()  # Направление сохраняем глобально
			timer = change_direction
			is_stopped = false
		else:
			direction = Vector2.ZERO  # Останавливаем врага
			timer = stop_timer
			is_stopped = true

	velocity = direction * speed
	$AnimatedSprite2D.play("default")
	move_and_slide()

func random_direction() -> Vector2:
	var x = randi() % 3 - 1
	var y = randi() % 3 - 1
	var new_direction = Vector2(x, y).normalized()
	
	if new_direction != Vector2.ZERO:
		return new_direction
	else:
		return random_direction()  # Повторяем, если вдруг (0,0)
