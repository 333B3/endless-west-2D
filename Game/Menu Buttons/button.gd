extends Button

# Назва сцени, яку потрібно відкрити
const GAME_SCENE = "res://Game/World/World.tscn"

func _on_pressed():
	get_tree().change_scene_to_file(GAME_SCENE)
