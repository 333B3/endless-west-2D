extends Button


func _on_pressed():
	var Setting_menu = load("res://Game/Scene/Setting_menu.tscn")
	get_tree().change_scene_to_packed(Setting_menu)
