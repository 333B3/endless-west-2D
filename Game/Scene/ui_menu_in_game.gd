extends Control

func _process(delta):
	CheckESC()

func resume():
	get_tree().paused = false
	$".".visible = false

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

#func _on_main_menu_pressed():
	#if get_tree().paused:
		#get_tree().paused = false
	#SceneManager.change_scene(
		#"res://Game/Menu Buttons/menu.tscn", {
			#"pattern_enter" : "circle",
			#"pattern_leave" : "fade",
		#}
	#)

func _on_setting_pressed():
	pass # Replace with function body.

func _on_save_pressed():
	pass # Replace with function body.

func _on_load_pressed():
	pass # Replace with function body.
