extends CanvasLayer

@onready var inventory_panel := $Inventory
@onready var toggle_button := $ToggleButton

var inventory: Array = []  # Змінна для зберігання списку предметів
var hotbarSlot
var inventorySlot
var slot: Array = []  # Ініціалізуємо масив

var inventory_open := false

func _ready(): 
	inventory_panel.visible = false
	toggle_button.pressed.connect(_on_toggle_button_pressed)
	
	if has_node("Node"):
		var inv_node = $Node
		if inv_node is Inventory:
			inv_node.item_added.connect(_on_item_added)  # Підключаємо сигнал
			if inv_node.Item is Dictionary:
				for key in inv_node.Item.keys():
					var inventory_entry = inv_node.Item[key]
					if inventory_entry.has("item") and inventory_entry["item"] != null:
						for i in range(inventory_entry["count"]):
							inventory.append(inventory_entry["item"])
	if has_node("hotbar"):
		for i1 in $hotbar.get_children():
			slot.append(i1)
	if has_node("Inventory"):
		for i2 in $Inventory.get_children():
			slot.append(i2)
	print(slot)
	
	var i = 0
	for item in inventory:
		if i < slot.size():
			slot[i].item = item
			i += 1

func _on_item_added(item: Item):
	update_inventory_slots()

func update_inventory_slots():
	for s in slot:
		s.item = null
		s.count = 0
	
	if has_node("Node"):
		var inv_node = $Node
		if inv_node is Inventory:
			var i = 0
			for key in inv_node.Item.keys():
				var entry = inv_node.Item[key]
				if entry.has("item") and entry["item"] != null:
					if i < slot.size():
						slot[i].item = entry["item"]
						slot[i].count = entry["count"]
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
