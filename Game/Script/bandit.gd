extends CharacterBody2D

var speed = 50
var player_in_area = false
var player
var dead = false

func _ready():
	randomize()
	dead = false

func _physics_process(delta):
	if dead:
		$detector/CollisionShape2D.disabled = true
		return

	# Если игрок в зоне обнаружения, двигаемся к нему
	if player_in_area and player:
		var direction = (player.position - position).normalized()
		velocity = direction * speed
	else:
		# Если игрок не в зоне, останавливаемся
		velocity = Vector2.ZERO

	move_and_slide()
	play_animation()

func play_animation():
	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("run")

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
