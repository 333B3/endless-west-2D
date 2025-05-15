extends RigidBody2D


@export var item: Item = null:
	set(value):
		item = value
		if value != null:
			$TextureRect.texture = value.texture
		else:
			$TextureRect.texture = null

func _ready():
	add_to_group("item")  
	add_to_group("weapon")  
