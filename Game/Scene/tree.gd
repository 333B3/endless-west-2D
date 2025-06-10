extends StaticBody2D

@export var health := 3
@export var item_scene: PackedScene

func _ready():
	pass

func hit():
	health -= 1
	if health <= 0:
		die()

func die():
	drop_items()
	queue_free()

func drop_items():
	if item_scene:
		var drop = item_scene.instantiate()
		drop.global_position = global_position
		get_tree().current_scene.add_child(drop)


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
