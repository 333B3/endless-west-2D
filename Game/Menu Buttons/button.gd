extends Button

@onready var animation_player = $"../AnimationPlayer"


func _on_pressed():
	SceneManager.change_scene(
		"res://Game/Main_Map/main_loc.tscn", {
			"pattern_enter" : "circle",
			"pattern_leave" : "fade",
		}
	)
