extends Button

@onready var animation_player = $"../AnimationPlayer"


func _on_pressed():
	var mainLoc = load("res://Game/Main_Map/main_loc.tscn")
	get_tree().change_scene_to_packed(mainLoc)
