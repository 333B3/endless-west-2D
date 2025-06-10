extends StaticBody2D

@export var health := 5
@export var item_scene: PackedScene

var player_in_area = false

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("shoot") and player_in_area == true:
		print("damage")
		print(health)
		hit()
	else:
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

func destruction_tree():
	pass



func _on_destruction_area_entered(area):
	if area.is_in_group("player"):
		print("12345")
		player_in_area = true


func _on_destruction_area_exited(area):
	if area.is_in_group("player"):
		print("54321")
		player_in_area = false
