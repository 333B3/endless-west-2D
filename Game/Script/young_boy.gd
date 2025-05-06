extends CharacterBody2D

var walk_speed = 75
var run_speed = 175
var last_direction: String = "down" 
var health = 100 

var damage = 5
var DamageBow = 10
var BowHit = false

var bullet_equip = false
var bullet_cooldown = true
var bullet = preload("res://Game/World/bullet.tscn")
var mouse_lock = null
var attacking = false
var death = false

var hit_player_by_mob = false

@onready var hit_timer = $HitTimer  

func _ready():
	hit_timer.wait_time = 0.9  
	hit_timer.one_shot = false  

func _process(_delta):
	$CanvasLayer/Label.text = str(health)
	mouse_lock = get_global_mouse_position() - self.position
	
	var movement = movement_vector()
	var direction = movement.normalized()
	var current_speed = walk_speed
	
	if bullet_equip == true and Input.is_action_just_pressed("shoot") and !attacking:
		attack()


	# ПРОВЕРКА КНОПКИ ШИФТ
	if Input.is_action_pressed("run"):
		current_speed = run_speed

	velocity = current_speed * direction


	if attacking == true:
		if abs(mouse_lock.x) > abs(mouse_lock.y):
			if mouse_lock.x > 0:
				$AnimatedSprite2D.play("attack_right")  # Правая сторона
			else:
				$AnimatedSprite2D.play("attack_left")   # Левая сторона
		else:
			if mouse_lock.y > 0:
				$AnimatedSprite2D.play("attack_down")  # Нижняя сторона
			else:
				$AnimatedSprite2D.play("attack_up") 
	elif bullet_equip and attacking != true:
		if abs(mouse_lock.x) > abs(mouse_lock.y):
			if mouse_lock.x > 0:
				$AnimatedSprite2D.play("wait_right")  # Правая сторона
			else:
				$AnimatedSprite2D.play("wait_left")   # Левая сторона
		else:
			if mouse_lock.y > 0:
				$AnimatedSprite2D.play("wait_down")  # Нижняя сторона
			else:
				$AnimatedSprite2D.play("wait_up") 
	elif movement != Vector2.ZERO and bullet_equip == false:
		if movement == Vector2(1, 0):
			last_direction = "right"
			if current_speed == run_speed:
				$AnimatedSprite2D.play("run_right")
			else:
				$AnimatedSprite2D.play("walk_right")
		elif movement == Vector2(-1, 0):
			last_direction = "left"
			if current_speed == run_speed:
				$AnimatedSprite2D.play("run_left")
			else:
				$AnimatedSprite2D.play("walk_left")
		elif movement == Vector2(0, -1):
			last_direction = "up"
			if current_speed == run_speed:
				$AnimatedSprite2D.play("run_up")
			else:
				$AnimatedSprite2D.play("walk_up")
		elif movement == Vector2(0, 1):
			last_direction = "down"
			if current_speed == run_speed:
				$AnimatedSprite2D.play("run_down")
			else:
				$AnimatedSprite2D.play("walk_down")
	else:
		# Idle анимация соответствует последнему положению игрока
		$AnimatedSprite2D.play("idle_" + last_direction)

	move_and_slide()

	var mouse_position = get_global_mouse_position()
	$Marker2D.look_at(mouse_position)
	
	if Input.is_action_just_pressed("shoot") and bullet_equip and bullet_cooldown:
		bullet_cooldown = false
		var bullet_instance = bullet.instantiate()
		bullet_instance.rotation = $Marker2D.rotation
		bullet_instance.global_position = $Marker2D.global_position
		add_child(bullet_instance)
		await get_tree().create_timer(0.8).timeout
		bullet_cooldown = true
		
	if Input.is_action_just_pressed("shoot_mode"):
		if bullet_equip:
			bullet_equip = false
		else:
			bullet_equip = true
	
	play_animation(direction)
	
func play_animation(dir):
	if !bullet_equip:
		walk_speed = 75
		run_speed = 150
	if bullet_equip:
		walk_speed = 0
		run_speed = 0


func movement_vector():
	var movement_x = Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")
	var movement_y = Input.get_action_strength("walk_down") - Input.get_action_strength("walk_up")
	return Vector2(movement_x, movement_y)
	
func attack():
	attacking = true  
	await get_tree().create_timer(0.8).timeout  
	attacking = false  

func  take_damage_by_bow(DamageBow):
	if !death:
		health -= DamageBow
		BowHit = true
		await get_tree().create_timer(0.6).timeout 
		BowHit = false  

		if health <= 0:
			death_player()

func take_damage(damage):
	if !death:
		health -= damage
		hit_player_by_mob = true

		#await get_tree().create_timer(0.6).timeout 
		#hit_player_by_mob = false  

		if health <= 0:
			death_player()

func player():
	pass

func _on_area_2d_area_entered(area):
	if area.is_in_group("hit"):
		hit_player_by_mob = true
		hit_timer.wait_time = 0.9  
		hit_timer.start() 

func _on_area_2d_area_exited(area):
	if area.is_in_group("hit"):
		hit_player_by_mob = false
		hit_timer.stop()  

func _on_hit_timer_timeout():
	if hit_player_by_mob == true:
		take_damage(damage)

func death_player():
	death = true
	walk_speed = 0
	run_speed = 0
	
	queue_free()
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(5).timeout

	$Dead_menu.visible = true


func _on_hit_box_area_entered(area):
	if area.is_in_group("Bow"):
		take_damage(10)
		
