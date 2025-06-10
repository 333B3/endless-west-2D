extends Control

func _process(delta):
	CheckESC()

func resume():
	get_tree().paused = false
	$".".visible = false
	$TextureRect.visible = false

func pause():
	$".".visible = true
	get_tree().paused = true

func CheckESC():
	if Input.is_action_just_pressed("esc"):
		if !get_tree().paused:
			pause()
		else:

			resume()

func _on_resume_pressed():
	resume()

func _on_main_menu_pressed():
	var mainMenu = load("res://Game/Menu_Buttons/menu.tscn")
	get_tree().change_scene_to_packed(mainMenu)

func _on_setting_pressed():
	$TextureRect.visible = true

func _on_save_pressed():
	pass # Replace with function body.

func _on_load_pressed():
	pass # Replace with function body.


func _on_back_in_game_setting_pressed():
	$TextureRect.visible = false
