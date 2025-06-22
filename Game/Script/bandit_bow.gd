extends CharacterBody2D

var speed = 50

var change_direction = 2
var timer = 1.0
var stop_timer = 3
var is_stopped = false

var health = 100
var dead = false

var player_in_area = false
var is_taking_damage = false  

var player: Node2D

var min_distance = 150 
var attack_range = 300 
var attack_cooldown = 2 
var can_attack = true 

var is_attacking = false

var hit_sound = false

func _ready():
	randomize()
	dead = false
	player_in_area = false

func _physics_process(delta):


	if is_attacking == true:
		hit_sound = true
		await get_tree().create_timer(0.1).timeout 
		hit_sound = false

	if can_attack == false:
		attack()

	if !is_taking_damage and !dead:
		if player_in_area and player:
			var direction = player_direction().normalized()
			var distance = global_position.distance_to(player.global_position)
			
			if distance > min_distance and distance < attack_range: 
				velocity = speed * direction.normalized()
			else:
				velocity = Vector2.ZERO
				
				if distance <= attack_range and can_attack:
					attack_player()
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
	elif is_attacking:  # Проверка на состояние атаки
		$AnimatedSprite2D.play("bow")
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

func death():
	dead = true
	speed = 0
	#$hit.queue_free()
	play_animation()
	await get_tree().create_timer(6).timeout
	queue_free()

func attack_player():
	if !can_attack:  # Проверяем, можно ли атаковать
		return
	can_attack = false
	await get_tree().create_timer(attack_cooldown).timeout  
	var arrow_scene = preload("res://Game/World/Bow.tscn")
	$hit2.play()
	var arrow = arrow_scene.instantiate()  
	arrow.set_direction(player_direction())
	#var spawn_offset = player_direction() * 40  
	arrow.global_position = global_position 
	#+ spawn_offset
	add_child(arrow) 
	#await get_tree().create_timer(attack_cooldown).timeout 
	can_attack = true  
	
func attack():
	is_attacking = true 
	await get_tree().create_timer(2).timeout  
	is_attacking = false  

func _on_hit_box_area_exited(area):
	pass # Replace with function body.
