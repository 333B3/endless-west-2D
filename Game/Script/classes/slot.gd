extends Panel

class_name Slot

@onready var texture_rect = $TextureRect

@export var item :Item = null:
	set(value):
		item = value
		
		if value != null:
			$TextureRect.texture = value.texture
		else:
			$TextureRect.texture = null
	
@export var count :int = 1:
	set(value):
		count = value
		if value != null:
			$Label.text = str(value)
		else:
			$Label.text = "i"
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
