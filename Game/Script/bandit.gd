extends CharacterBody2D

var speed = 50
var direction = Vector2.ZERO
var change_direction = 1.0
var timer = 1.0
var stop_timer = 2
var is_stopped = false

var heath = 100 
var damage = 10
var dead = false
var player_in_area = false
var player


func _ready():
	randomize()
	var dead = false

func _physics_process(_delta):
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
	if !dead:
		$detector/CollisionShape2D.disabled = false
		if player_in_area:
			position +=(player.position - position) / speed
	if dead:
		$detector/CollisionShape2D.disabled = true

func random_direction() -> Vector2:
	var x = randi() % 3 - 1
	var y = randi() % 5 - 1
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





#func _on_detector_body_entered(body):
	#if body.has_method(player):
		#player_in_area = true
		#player = body



#func _on_detector_body_exited(body):
	#if body.has_method(player):
		#player_in_area = false
