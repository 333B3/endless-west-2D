extends Button

@onready var animation_player = $"../AnimationPlayer"


func _on_pressed():
	#animation_player.play("FadeOut")  # Анімація затемнення
	#await animation_player.animation_finished  # Чекаємо завершення
	
	get_tree().change_scene_to_file("res://Game/Main_Map/main_loc.tscn")
