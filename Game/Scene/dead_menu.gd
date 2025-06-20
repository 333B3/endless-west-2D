extends Control


func _process(delta):
	pass


func _ready():
	var mainLoc = load("res://Game/Main_Map/main_loc.tscn")
	var mainMenu = load("res://Game/Menu_Buttons/menu.tscn")

func _on_load_pressed():
	pass # Replace with function body.

func _on_main_menu_pressed():
	var mainMenu = load("res://Game/Menu_Buttons/menu.tscn")
	get_tree().change_scene_to_packed(mainMenu)


func _on_resume_pressed():
	var mainLoc = load("res://Game/Main_Map/main_loc.tscn")
	get_tree().change_scene_to_packed(mainLoc)
