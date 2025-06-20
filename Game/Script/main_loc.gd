extends TileMapLayer

func _on_area_2d_41_area_entered(area):
	if area.is_in_group("player"):
		var nextLoc = load("res://Game/World/World.tscn")
		get_tree().change_scene_to_packed(nextLoc)
