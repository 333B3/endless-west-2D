extends CanvasLayer

@onready var inventory_panel := $Inventory
@onready var toggle_button := $ToggleButton

var inventory
var hotbarSlot
var inventorySlot

var inventory_open := false

func _ready(): 
	inventory_panel.visible = false
	toggle_button.pressed.connect(_on_toggle_button_pressed)
	inventory = $Node.Item
	var i = 0
	for item in inventory:
		$hotbar.get_child(i).item = item
		i += 1
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("Inventory"):
		_toggle_inventory()

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if get_viewport().gui_get_hovered_control() == null:
			pass

func _on_toggle_button_pressed() -> void:
	_toggle_inventory()

func _toggle_inventory():
	inventory_open = not inventory_open
	inventory_panel.visible = inventory_open
