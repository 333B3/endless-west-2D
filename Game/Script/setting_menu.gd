extends Control


func _on_back_pressed():
	var MainMenu = load("res://Game/Menu Buttons/menu.tscn")
	get_tree().change_scene_to_packed(MainMenu)
