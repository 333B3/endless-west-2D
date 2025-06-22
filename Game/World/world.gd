extends Node2D

@export var house_scene: PackedScene = preload("res://Game/build/house.tscn")

var preview_instance: Node2D = null
var is_in_build_mode = false
var can_build = false
var inventory: Inventory = null

@onready var preview_container: Node2D = $PreviewContainer 

func _ready() -> void:
	var ui = get_node_or_null("Main_Character/CanvasLayer2")
	if ui != null:
		if ui.has_signal("build_button_pressed"):
			ui.connect("build_button_pressed", Callable(self, "_on_place_button_pressed"))
		inventory = ui.get_inventory() 
	else:
		push_error("❌ Не знайдено UI або сигналу!")


func _process(delta: float) -> void:
	if is_in_build_mode and preview_instance:
		preview_instance.position = get_global_mouse_position().snapped(Vector2(50, 50))
		preview_instance.modulate = Color(0, 1, 0, 0.5) if can_build else Color(1, 0, 0, 0.5)
		
func _unhandled_input(event: InputEvent) -> void:
	if is_in_build_mode and event.is_action_released("place_house"):
		print("Спроба поставити будівлю!")

		if preview_instance:
			if not can_build:
				print("❌ Не можна будувати тут — є перешкода!")
				return

			if not has_enough_wood(5):
				print("❌ Не вистачає дерева для побудови!")
				return

			var placed_house = house_scene.instantiate()
			placed_house.position = preview_instance.position
			add_child(placed_house)

			inventory.remove_item_by_name("Wood", 15)

			preview_instance.queue_free()
			preview_instance = null
			is_in_build_mode = false
			print("✅ Будівлю поставлено!")


func _physics_process(delta: float) -> void:
	if preview_instance:
		var world_space = get_world_2d().direct_space_state
		var params = PhysicsShapeQueryParameters2D.new()
		params.collide_with_areas = true
		params.collide_with_bodies = true
		params.shape = RectangleShape2D.new()
		params.shape.size = Vector2(54, 50)
		params.transform = Transform2D(0, preview_instance.global_position)
		
		params.collision_mask = 1 << 2  

		var collision = world_space.collide_shape(params, 1)
		can_build = collision.is_empty()
  


func _on_place_button_pressed():
	print("Кнопка натиснута!")

	if house_scene == null:
		push_error("❌ house_scene не призначено!")
		return

	if preview_container == null:
		push_error("❌ PreviewContainer не знайдено!")
		return

	# Якщо прев'ю вже існує — вимикаємо режим будівництва
	if preview_instance != null:
		print("ℹ️ Вихід з режиму будівництва")
		preview_instance.queue_free()
		preview_instance = null
		is_in_build_mode = false
	else:
		preview_instance = house_scene.instantiate()
		preview_instance.modulate = Color(1, 1, 1, 0.5)  
		preview_instance.visible = true
		preview_container.add_child(preview_instance)
		is_in_build_mode = true
		print("✅ Preview створено і додано до PreviewContainer")
		
func has_enough_wood(amount: int) -> bool:
	if inventory == null:
		print("❌ Інвентар не знайдено")
		return false

	for key in inventory.Item:
		var entry = inventory.Item[key]
		if entry.has("item") and entry["item"].item_name == "Wood":
			if entry["count"] >= amount:
				return true
			else:
				print("⚠️ Недостатньо дерева: є ", entry["count"], ", потрібно ", amount)
				return false
	return false


func _on_area_2d_2_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		$CanvasLayer2.visible = true
		$CanvasLayer2/AnimationPlayer.play("fade")
		await get_tree().create_timer(0.4).timeout
		var nextLoc = load("res://Game/Main_Map/main_loc.tscn")
		get_tree().change_scene_to_packed(nextLoc)
