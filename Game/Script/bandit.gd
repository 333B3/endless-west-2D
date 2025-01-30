extends CharacterBody2D

var speed = 50
var change_direction = 2
var timer = 1.5
var stop_timer = 2
var is_stopped = false

var health = 100
var damage = 10
var dead = false
var player_in_area = false

var player: Node2D
var min_distance = 15

func _ready():
	randomize()
	dead = false
	player_in_area = false

func _physics_process(delta):
	if player_in_area and player:
		var direction = player_direction()
		var distance = global_position.distance_to(player.global_position)
		
		if distance > min_distance: 
			velocity = speed * direction
		else:  
			velocity = Vector2.ZERO
	else:
		timer -= delta
		if timer <= 0:
			if is_stopped:
				var direction = random_direction()
				velocity = direction * speed
				timer = change_direction
				is_stopped = false
			else:
				velocity = Vector2.ZERO
				timer = stop_timer
				is_stopped = true

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
	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("run")

func player_direction() -> Vector2:
	if player:
		return (player.global_position - global_position).normalized()
	return Vector2.ZERO

func _on_detector_area_entered(area):
	if area.is_in_group("player"):
		player_in_area = true
		player = area.get_parent()

func _on_detector_area_exited(area):
	if area.is_in_group("player"):
		player_in_area = false
		player = null
