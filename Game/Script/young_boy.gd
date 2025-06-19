extends CharacterBody2D

var walk_speed = 75
var run_speed = 175
var last_direction: String = "down" 
var health = 100 

var damage = 5
var big_damage = 20
var DamageBow = 10
var BowHit = false

var bullet_equip = false
var bullet_cooldown = true
var bullet = preload("res://Game/World/bullet.tscn")
var mouse_lock = null
var attacking = false
@export var death := false

var hit_player_by_mob = false
var hit_player_by_big_mob = false

var trader_in_area = false
var is_chatting = true
var is_roaming = false
var inventory_open: bool = false

@onready var inventory_ui := get_node("CanvasLayer2")  
@onready var weapon_slot: Slot = get_node("CanvasLayer2/WeaponSlot/slot")  
@onready var inventory_node := get_node("CanvasLayer2/Node")  
@onready var tilemap_tree = get_node("Area2D")
@onready var tree_scene = preload("res://Game/Scene/Tree.tscn")

@onready var hit_timer = $HitTimer  

var near_tree = false
var hit_tree = false

@onready var regen_delay_timer = $RegenDelayTimer  
@onready var regen_interval_timer = $RegenIntervalTimer  

func _ready():
	# Налаштування таймерів
	regen_delay_timer.wait_time = 5.0
	regen_delay_timer.one_shot = true
	regen_interval_timer.wait_time = 0.5
	regen_interval_timer.one_shot = false
	regen_delay_timer.stop()
	regen_interval_timer.stop()
	print("Таймери ініціалізовані")

	hit_timer.wait_time = 0.9  
	hit_timer.one_shot = false  
	# Скидаємо weapon_slot.item, якщо він не в інвентарі
	if weapon_slot and weapon_slot.item != null:
		print("Перевірка при старті: weapon_slot.item = ", weapon_slot.item.item_name if weapon_slot.item else "null")
		if not is_item_in_inventory(weapon_slot.item):
			print("Предмет у weapon_slot не в інвентарі, скидаємо weapon_slot.item")
			weapon_slot.item = null
			bullet_equip = false 
		else:
			print("Предмет у weapon_slot знайдено в інвентарі")

func _process(_delta):
	if Input.is_action_just_pressed("shoot") and near_tree == true and bullet_equip == false:
		print("bumbum")
		hit_tree = true
		await get_tree().create_timer(0.8).timeout
		hit_tree = false
	else:
		pass
		# ДИАЛОГ
	if trader_in_area:
		if Input.is_action_just_pressed("action"):
			run_dialogue("First")
	$CanvasLayer/Label.text = str(health)
	mouse_lock = get_global_mouse_position() - self.position
		#КОНЕЦ ДИАЛОГА
	
	var movement = movement_vector()
	var direction = movement.normalized()
	var current_speed = walk_speed

	# Отримуємо позицію миші
	var mouse_pos = get_viewport().get_mouse_position()
	var ui_node = get_node("CanvasLayer2")  

	# Перевірка: миша не над UI
	var is_mouse_over_ui = false
	if ui_node:
		for control in ui_node.get_children():
			if control is Control and control.is_visible_in_tree() and control.get_global_rect().has_point(mouse_pos):
				is_mouse_over_ui = true
				break

	if Input.is_action_just_pressed("shoot"):
		if weapon_slot and weapon_slot.item != null and weapon_slot.is_in_group("weapon"):
			print("Спроба використати зброю. weapon_slot.item = ", weapon_slot.item.item_name if weapon_slot.item else "null")
			print("Інвентар відкритий: ", inventory_open, ", Миша над UI: ", is_mouse_over_ui, ", У інвентарі: ", is_item_in_inventory(weapon_slot.item))
			if not inventory_open and not is_mouse_over_ui and is_item_in_inventory(weapon_slot.item):
				use_weapon()
			else:
				print("Використання заблоковано: Інвентар відкритий: ", inventory_open, ", Миша над UI: ", is_mouse_over_ui, ", Предмет у інвентарі: ", is_item_in_inventory(weapon_slot.item))

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
				$AnimatedSprite2D.play("attack_up") #Верх
	elif near_tree == true and bullet_equip == false and hit_tree == true:
		$AnimatedSprite2D.play("slash")

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
	
	# Оновлена логіка стрільби з bullet_equip
	if Input.is_action_just_pressed("shoot") and bullet_equip and bullet_cooldown:
		if weapon_slot and weapon_slot.item != null and is_item_in_inventory(weapon_slot.item):
			bullet_cooldown = false
			var bullet_instance = bullet.instantiate()
			bullet_instance.rotation = $Marker2D.rotation
			bullet_instance.global_position = $Marker2D.global_position
			add_child(bullet_instance)
			await get_tree().create_timer(0.8).timeout
			bullet_cooldown = true
		else:
			print("Не можна стріляти: зброя не екіпірована або не в інвентарі")
			bullet_equip = false  # Скидаємо bullet_equip, якщо зброя відсутня
	
	if Input.is_action_just_pressed("shoot_mode"):
		if weapon_slot and weapon_slot.item != null and is_item_in_inventory(weapon_slot.item):
			bullet_equip = not bullet_equip
			print("Переключено bullet_equip на: ", bullet_equip)
		else:
			bullet_equip = false
			print("Не можна переключити режим: зброя не екіпірована або не в інвентарі")
	
	play_animation(direction)
	
	if health > 0 and regen_delay_timer.is_stopped():
		regen_delay_timer.start()

func _on_regen_delay_timer_timeout():
	if health < 100:  # Початок відновлення тільки якщо здоров’я менше 100
		$RegenIntervalTimer.start()

func _on_regen_interval_timer_timeout():
	if health < 100:
		health += 1
	else:
		health = 100  # Обмежуємо максимум
		regen_interval_timer.stop()


func use_weapon():
	var weapon = weapon_slot.item
	if weapon != null and weapon.is_in_group("weapon"):
		weapon.use()
	else:
		print("У слоті зброї немає зброї або це не зброя!")

func play_animation(dir):
	if !bullet_equip:
		walk_speed = 75
		run_speed = 150
	if bullet_equip:
		walk_speed = 0
		run_speed = 0

func run_dialogue(dialogue_string):
	is_chatting = true
	is_roaming = false
	var layout = Dialogic.start(dialogue_string)
	layout.register_character(load("res://Game/dialogic/character/John.dch"), $".")

func movement_vector():
	var movement_x = Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")
	var movement_y = Input.get_action_strength("walk_down") - Input.get_action_strength("walk_up")
	return Vector2(movement_x, movement_y)
	
func attack():
	attacking = true  
	await get_tree().create_timer(0.8).timeout  
	attacking = false  
	
func hit_tree_timer():
	if Input.is_action_just_pressed("shoot"):
		hit_tree = true
		await get_tree().create_timer(0,7).timeout
		hit_tree = false


func take_damage_by_bow(DamageBow):
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
		if health <= 0:
			death_player()

func take_big_damage(big_damage):
	if !death:
		health -= big_damage
		hit_player_by_big_mob = true
		if health <= 0:
			death_player()

func player():
	pass

func _on_area_2d_area_entered(area):
	if area.is_in_group("hit"):
		hit_player_by_mob = true
		hit_timer.wait_time = 0.9  
		hit_timer.start() 
			
	if area.is_in_group("trader"):
		trader_in_area = true
		
	if area.is_in_group("Hit_Big_Bandit"):
		hit_player_by_big_mob = true
		hit_timer.wait_time = 0.9  
		hit_timer.start() 
	
	if area.is_in_group("tree"):
		near_tree = true

func _on_area_2d_area_exited(area):
	if area.is_in_group("hit"):
		hit_player_by_mob = false
		hit_timer.stop()  
	if area.is_in_group("trader"):
		trader_in_area = false
	if area.is_in_group("Hit_Big_Bandit"):
		hit_player_by_big_mob = false
		hit_timer.stop() 

	if area.is_in_group("tree"):
		near_tree = false

func _on_hit_timer_timeout():
	if hit_player_by_mob == true:
		take_damage(damage)
	if hit_player_by_big_mob == true:
		take_big_damage(big_damage)

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

func _on_pick_item_area_entered(area: Area2D) -> void:
	print("Area2D: ", area)
	var item_node = area.get_parent()
	if item_node and item_node.is_in_group("item"):
		var item = item_node.get("item")
		print("Пiдiбрано предмет: ", item.item_name if item else "null")
		if item:
			var inventory_node = get_node("CanvasLayer2/Node")
			if inventory_node:
				inventory_node.add_item(item)
				print("Додано до інвентарю: ", inventory_node.get_items())
				item_node.queue_free()
				# Скидаємо weapon_slot.item, якщо він не в інвентарі
				if weapon_slot and weapon_slot.item != null and not is_item_in_inventory(weapon_slot.item):
					print("Скидаємо weapon_slot.item, бо не в інвентарі")
					weapon_slot.item = null
					bullet_equip = false

# Перевірка, чи предмет у інвентарі
func is_item_in_inventory(item_to_check):
	if inventory_node and inventory_node.has_method("get_items"):
		var items = inventory_node.get_items()
		print("Поточні предмети в інвентарі: ", items)
		for item in items:
			if item and item_to_check and item.item_name == item_to_check.item_name: 
				return true
	return false
	
func try_cut_tree(global_position: Vector2):
	var local_pos = tilemap_tree.to_local(global_position)
	var cell = tilemap_tree.local_to_map(local_pos)
	
	var tile_id = tilemap_tree.get_cell_source_id(0, cell)
	if tile_id != -1:
		if tile_id == 0:
			# Видаляємо тайл дерева
			tilemap_tree.erase_cell(0, cell)

			# Додаємо сцену дерева
			var tree = tree_scene.instantiate()
			var tree_pos = tilemap_tree.map_to_local(cell)
			tree.global_position = tilemap_tree.to_global(tree_pos)
			get_tree().current_scene.add_child(tree)
			
