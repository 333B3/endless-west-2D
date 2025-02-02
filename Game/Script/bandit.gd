extends CharacterBody2D

var speed = 50
var change_direction = 2
var timer = 1.5
var stop_timer = 2
var is_stopped = false

var health = 100
var dead = false
var player_in_area = false
var is_taking_damage = false  

var player: Node2D
var min_distance = 15

var hit_player = false



func _ready():
	randomize()
	dead = false
	player_in_area = false

func _physics_process(delta):
	if !is_taking_damage:  
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
	if is_taking_damage:
		$AnimatedSprite2D.play("damage") 
		$AnimatedSprite2D2.stop() 
	elif dead:
		$AnimatedSprite2D.play("bandit_death")
		$AnimatedSprite2D2.stop()
	elif hit_player:
		$AnimatedSprite2D.play("attack")
		$AnimatedSprite2D2.stop() 
	elif velocity != Vector2.ZERO:
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D2.play("dust")
	else:
		$AnimatedSprite2D.play("idle")
		$AnimatedSprite2D2.stop()

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

func _on_hit_box_area_entered(area):
	if area.is_in_group("bullet"):
		take_damage(50)

func take_damage(damage):
	if !dead:
		health -= damage
		is_taking_damage = true
		play_animation()

		await get_tree().create_timer(0.6).timeout 
		is_taking_damage = false  

		if health <= 0:
			death()
func _on_hit_area_entered(area):
	print(123)
	if area.is_in_group("player"):
		hit_player = true



func _on_hit_area_exited(area):
	if area.is_in_group("player"):
		hit_player = false

func death():
	dead = true
	speed = 0
	play_animation()
	await get_tree().create_timer(5).timeout
	queue_free()
