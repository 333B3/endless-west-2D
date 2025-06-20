extends StaticBody2D

@export var health := 4
@export var item_scene: PackedScene
@export var item_data: Item

var player_in_area = false
var is_animating = false

@onready var animated_sprite = $AnimatedSprite2D

func _process(_delta):
	if health == 4:
		animated_sprite.play("idle")
	elif health == 3:
		animated_sprite.play("hit")
	elif health == 0 and not is_animating:
		animated_sprite.play("down")

	if Input.is_action_just_pressed("shoot") and player_in_area:
		print("Tree HP:", health)
		hit()
	

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "down":
		animated_sprite.stop()
		animated_sprite.frame = animated_sprite.sprite_frames.get_frame_count("down") - 1
		is_animating = false

func hit():
	health -= 1
	if health == 0:
		die()

func die():
	$CollisionShape2D.disabled = true
	$CollisionShape2D2.disabled = false
	$tree_crash.play()
	drop_items()

func drop_items():
	if item_scene:
		var drop = item_scene.instantiate()

		# !!! Встановлюємо item_data тут !!!
		drop.item_data = load("res://Game/Item/Wood.tres")  

		drop.global_position = global_position
		get_tree().current_scene.add_child(drop)
	else:
		push_error("❌ item_scene не встановлено!")


func _on_destruction_area_entered(area):
	if area.is_in_group("player"):
		player_in_area = true

func _on_destruction_area_exited(area):
	if area.is_in_group("player"):
		player_in_area = false
