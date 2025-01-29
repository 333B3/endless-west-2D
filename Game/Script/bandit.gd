extends CharacterBody2D

var speed = 50
var direction = Vector2.ZERO
var change_direction = 1.0
var timer = 1.0
var stop_timer = 2
var is_stopped = false

var health = 100
var damage = 10
var dead = false
var player_in_area = false
var player: Node2D

func _ready():
	randomize()
	dead = false

func _physics_process(delta):
	timer -= delta
	if timer <= 0:
		if is_stopped:
			direction = random_direction()
			timer = change_direction
			is_stopped = false
		else:
			direction = Vector2.ZERO
			timer = stop_timer
			is_stopped = true

	if !dead:
		if player_in_area:
			# Враг движется к игроку
			var direction_to_player = (player.global_position - global_position).normalized()
			velocity = direction_to_player * speed
		else:
			velocity = direction * speed
	else:
		velocity = Vector2.ZERO

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

# Коллизия с зонами (если игрок - Area2D)
func _on_detector_area_entered(area):
	print("Player entered area!")  # Отладочное сообщение
	if area.is_in_group("player"):
		player_in_area = true
		player = area.get_parent()
		print("Player object:", player)  # Отладочное сообщение

func _on_detector_area_exited(area):
	print("Player left area!")  # Отладочное сообщение
	if area.is_in_group("player"):
		player_in_area = false
