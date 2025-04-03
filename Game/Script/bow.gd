extends Area2D

var speed = 300
var direction = Vector2.ZERO

func _ready():
	set_as_top_level(true)

func _process(delta):

	position += direction * speed * delta
	
	if direction != Vector2.ZERO:
		rotation = direction.angle()

func set_direction(new_direction: Vector2):

	direction = new_direction.normalized()

func bullet_deal_damage():
	pass

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
