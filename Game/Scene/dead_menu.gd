extends Control

@onready var young_boy = get_tree().get_first_node_in_group("Death_check")
@onready var death_menu = $"."

func _process(delta):
	if young_boy and young_boy.death:
		death_menu.visible = true
		#get_tree().paused = true
	else:
		death_menu.visible = false
		get_tree().paused = false

func _ready():
	death_menu.visible = false
	


func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	


func _on_load_pressed():
	pass # Replace with function body.


func _on_main_menu_pressed():
	get_tree().paused = false
	if get_tree().paused:
		get_tree().paused = false
	SceneManager.change_scene(
		"res://Game/Menu Buttons/menu.tscn", {
			"pattern_enter" : "circle",
			"pattern_leave" : "fade",
		}
	)
