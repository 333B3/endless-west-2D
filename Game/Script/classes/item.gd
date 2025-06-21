extends RigidBody2D

@export var item_data: Resource
var item: Resource  

func _ready():
	item = item_data  

	add_to_group("item")
	add_to_group("weapon")

	if item_data:
		if item_data is Item:
			if has_node("TextureRect"):
				$TextureRect.texture = item_data.texture
				print("✅ Завантажено предмет:", item_data.resource_name)
			else:
				push_error("❌ TextureRect не знайдено!")
		else:
			push_error("❌ item_data не є типом Item!")
	else:
		push_error("❌ item_data: null")
