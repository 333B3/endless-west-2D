extends CharacterBody2D

var speed = 50
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
	if player_in_area:
		print("GO GO GO")
		var direction = player_direction()  
		velocity = speed * direction  
	else:
		timer -= delta
		if timer <= 0:
			if is_stopped:
				var direction = random_direction()  
				velocity = direction * speed
				timer = change_direction
				is_stopped = false
			else:
				var direction = Vector2.ZERO  
				velocity = direction * speed
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
	if is_stopped:
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("run")

func player_direction() -> Vector2:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player:
		return (player.global_position - global_position).normalized()
	return Vector2.ZERO


func _on_detector_area_entered(area):
	print("Player entered area!")  
	player_in_area = true


func _on_detector_area_exited(area):
	print("Player left area!")  
	player_in_area = false
