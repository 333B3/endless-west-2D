extends RigidBody2D


@export var item: Item = null:
	set(value):
		item = value
		if value != null:
			$TextureRect.texture = value.texture
		else:
			$TextureRect.texture = null

func _ready():
	add_to_group("item")  # Додаємо цей вузол до групи "items"
	add_to_group("weapon")  # Додаємо до "weapon"
