extends Node2D

@export var house_scene: PackedScene = preload("res://Game/build/house.tscn")

var preview_instance: Node2D = null
var is_in_build_mode = false
var can_build = false

@onready var preview_container: Node2D = $PreviewContainer 

func _ready() -> void:
	var scene := preload("res://Game/World/Inventory.tscn")
	var ui = scene.instantiate() 
	add_child(ui) 

	if ui.has_signal("build_button_pressed"):
		ui.connect("build_button_pressed", Callable(self, "_on_place_button_pressed"))


func _process(delta: float) -> void:
	if is_in_build_mode and preview_instance:
		preview_instance.position = get_global_mouse_position().snapped(Vector2(50, 50))
		
func _unhandled_input(event: InputEvent) -> void:
	if is_in_build_mode and event.is_action_released("place_house"):
		print("Спроба поставити будівлю!")
		if preview_instance:
			var placed_house = house_scene.instantiate()
			placed_house.position = preview_instance.position
			add_child(placed_house)

			preview_instance.queue_free()
			preview_instance = null
			is_in_build_mode = false


func _physics_process(delta: float) -> void:
	if preview_instance:
		var world_space = get_world_2d().direct_space_state
		var params = PhysicsShapeQueryParameters2D.new()
		params.collide_with_areas = true
		params.collide_with_bodies = true
		params.shape = RectangleShape2D.new()
		params.shape.size = Vector2(108, 96)
		params.transform = Transform2D(0, preview_instance.global_position)
		var collision = world_space.collide_shape(params, 1)

		can_build = collision.is_empty()  # ← залиш тільки це


func _on_place_button_pressed():
	print("Кнопка натиснута!")

	if house_scene == null:
		push_error("house_scene не призначено!")
		return

	if preview_container == null:
		push_error("PreviewContainer не знайдено!")
		return

	if preview_instance == null:
		preview_instance = house_scene.instantiate()
		preview_instance.modulate = Color(1, 1, 1, 0.5)  # Прозорий вигляд
		preview_instance.visible = true
		preview_container.add_child(preview_instance)
		is_in_build_mode = true
	else:
		print("Preview вже існує")
