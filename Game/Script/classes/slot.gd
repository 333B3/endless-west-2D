extends Panel

class_name Slot

@onready var texture_rect = $TextureRect
@onready var label = $Label

@export var item : Item = null:
	set(value):
		item = value
		if value != null:
			texture_rect.texture = value.texture
			label.visible = count > 0  # показати, тільки якщо count > 1
		else:
			texture_rect.texture = null
			label.visible = false     # ховаємо, якщо item = null

@export var count : int = 0:
	set(value):
		count = value
		if item != null and value > 0:
			label.text = str(value)
			label.visible = true
		else:
			label.visible = false


func get_preview():
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture_rect.texture

	var preview = Control.new()
	preview.add_child(preview_texture)

	return preview

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(get_preview())
	return self

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Slot

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var temp = item
	item = data.item
	data.item = temp

	var temp_count = count
	count = data.count
	data.count = temp_count
