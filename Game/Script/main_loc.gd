extends TileMapLayer

func _on_area_2d_41_area_entered(area):
	if area.is_in_group("player"):
		$CanvasLayer2.visible = true
		$CanvasLayer2/AnimationPlayer.play("fade")
		await get_tree().create_timer(0.4).timeout
		var nextLoc = load("res://Game/World/World.tscn")
		get_tree().change_scene_to_packed(nextLoc)
