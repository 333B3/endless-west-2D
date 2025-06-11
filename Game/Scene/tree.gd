extends StaticBody2D

@export var health := 4
@export var item_scene: PackedScene

var player_in_area = false
var damage_tree = false

@onready var animated_sprite = $AnimatedSprite2D
var is_animating : bool = false

func _ready():
	pass

func _process(delta):
	if health == 4:
		$AnimatedSprite2D.play("idle")
	if health == 3:
		$AnimatedSprite2D.play("hit")
	if health <= 0 and not is_animating:
		animated_sprite.play("down")

	if Input.is_action_just_pressed("shoot") and player_in_area == true:
		print(health)
		hit()
	else:
		pass

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "down":
		# Зупиняємо анімацію і фіксуємо останній кадр
		$AnimatedSprite2D.stop()
		# Отримуємо кількість кадрів і встановлюємо останній
		var frame_count = animated_sprite.sprite_frames.get_frame_count("down")
		animated_sprite.frame = frame_count - 1  # Встановлюємо на останній кадр
		is_animating = false

func hit():
	health -= 1
	
	if health <= 0:
		die()

func die():
	$CollisionShape2D.disabled = true
	$CollisionShape2D2.disabled = false
	drop_items()
	#queue_free()

func drop_items():
	if item_scene:
		var drop = item_scene.instantiate()
		drop.global_position = global_position
		get_tree().current_scene.add_child(drop)

func destruction_tree():
	pass



func _on_destruction_area_entered(area):
	if area.is_in_group("player"):
		print("12345")
		player_in_area = true


func _on_destruction_area_exited(area):
	if area.is_in_group("player"):
		print("54321")
		player_in_area = false
