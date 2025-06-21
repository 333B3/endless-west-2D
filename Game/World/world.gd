extends Node2D

@export var house_scene: PackedScene = preload("res://Game/build/house.tscn")

var preview_instance: Node2D = null
var is_in_build_mode = false
var can_build = true  # Колізія вимкнена
var inv_node: Inventory = null

@onready var preview_container: Node2D = $PreviewContainer

func _ready() -> void:
	await get_tree().process_frame 
	var inventory_scene = load("res://Game/World/Inventory.tscn")  # Завантажуємо сцену
	if inventory_scene == null:
		push_error("❌ Сцена Inventory.tscn не знайдена!")
		return

	var ui = inventory_scene.instantiate()  # Створюємо інстанс сцени
	add_child(ui)  # Додаємо CanvasLayer до сцени World
	inv_node = ui.get_node_or_null("Node")  # Отримуємо вузол Node
	if inv_node == null:
		push_error("❌ Inventory не знайдено в UI!")
	else:
		print("✅ Інвентар знайдено: ", inv_node)
		# Тестове додавання Wood для діагностики
		var wood = load("res://Game/Item/Wood.tres") as Item
		if wood:
			print("Wood.tres завантажено. item_name: ", wood.item_name, " | Is Item: ", wood is Item)
			if not wood.item_name:
				push_warning("⚠️ item_name у Wood.tres порожнє! Встановлено значення 'Wood'.")
				wood.item_name = "Wood"  # Встановлюємо значення за замовчуванням
			for i in range(20):
				inv_node.add_item(wood)
				print("Додано Wood. Item count: ", inv_node.Item.size())
			print("✅ Додано 20 одиниць Wood до інвентарю. Загальна кількість слотів: ", inv_node.Item.size())
		else:
			push_error("❌ Wood.tres не завантажено або не є Item!")

	if ui.has_signal("build_button_pressed"):
		ui.connect("build_button_pressed", Callable(self, "_on_place_button_pressed"))

func _process(delta: float) -> void:
	if is_in_build_mode and preview_instance:
		preview_instance.position = get_global_mouse_position().snapped(Vector2(50, 50))
		preview_instance.modulate = Color(0, 1, 0, 0.5)  # Завжди зелений

func _unhandled_input(event: InputEvent) -> void:
	if is_in_build_mode and event.is_action_released("place_house"):
		print("Спроба поставити будівлю!")
		print("preview_instance: ", preview_instance != null, " | inv_node: ", inv_node != null, " | can_build: ", can_build)
		
		if preview_instance and inv_node and can_build:
			if has_required_wood(1):
				var placed_house = house_scene.instantiate()
				placed_house.position = preview_instance.position
				add_child(placed_house)

				inv_node.remove_item_by_name("Wood", 1)

				preview_instance.queue_free()
				preview_instance = null
				is_in_build_mode = false
				print("Будівля успішно розміщена!")
			else:
				print("Недостатньо деревини!")
		else:
			print("Не можна будувати: перешкода або відсутній інвентар!")

func _on_place_button_pressed():
	print("Кнопка натиснута!")

	if house_scene == null:
		push_error("house_scene не призначено!")
		return
	print("house_scene завантажено: ", house_scene != null)

	if preview_container == null:
		push_error("PreviewContainer не знайдено!")
		return
	print("PreviewContainer знайдено: ", preview_container != null)

	if preview_instance == null:
		preview_instance = house_scene.instantiate()
		if preview_instance == null:
			push_error("Не вдалося створити preview_instance!")
			return
		preview_instance.modulate = Color(1, 1, 1, 0.5)
		preview_instance.visible = true
		preview_container.add_child(preview_instance)
		is_in_build_mode = true
		print("Preview створено і додано до PreviewContainer")
	else:
		print("Preview вже існує")

func has_required_wood(amount: int) -> bool:
	if inv_node:
		var total_wood = 0
		for key in inv_node.Item:
			var entry = inv_node.Item[key]
			if entry.has("item"):
				print("Слот ", key, ": item_name = ", entry["item"].item_name, " | count = ", entry["count"])
				if entry["item"].item_name == "Wood":
					total_wood += entry["count"]
		print("📦 Всього деревини: ", total_wood)
		return total_wood >= amount
	else:
		print("❌ inv_node: null")
	return false
