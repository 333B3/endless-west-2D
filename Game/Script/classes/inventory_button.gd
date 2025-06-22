extends CanvasLayer

@onready var inventory_panel := $Inventory
@onready var toggle_button := $ToggleButton
@onready var weapon_slot := $WeaponSlot/slot  
@onready var place_button = $PlaceModeButton
@onready var inv_node: Inventory = $Node  

var slot: Array = []
var inventory_open := false

signal build_button_pressed
signal inventory_updated(inventory)

func _ready():
	inventory_panel.visible = false
	toggle_button.pressed.connect(_on_toggle_button_pressed)

	for i in $hotbar.get_children():
		slot.append(i)
	for i in $Inventory.get_children():
		slot.append(i)

	if inv_node:
		if not inv_node.is_connected("item_added", Callable(self, "_on_item_added")):
			inv_node.item_added.connect(_on_item_added)
		update_inventory_slots()
		emit_signal("inventory_updated", inv_node)
		print("UI: Інвентар ініціалізований: ", inv_node, " | ID: ", inv_node.get_instance_id(), " | Item: ", inv_node.Item)
	else:
		push_error("❌ UI: inv_node не знайдено!")

func set_inventory(inventory: Inventory):
	inv_node = inventory
	if inv_node:
		if not inv_node.is_connected("item_added", Callable(self, "_on_item_added")):
			inv_node.item_added.connect(_on_item_added)
		update_inventory_slots()
		emit_signal("inventory_updated", inv_node)
		print("UI: Інвентар встановлено ззовні: ", inv_node, " | ID: ", inv_node.get_instance_id(), " | Item: ", inv_node.Item)

func _on_toggle_button_pressed() -> void:
	_toggle_inventory()

func _toggle_inventory():
	inventory_open = not inventory_open
	inventory_panel.visible = inventory_open

func _on_item_added(item: Item):
	update_inventory_slots()
	emit_signal("inventory_updated", inv_node)
	print("UI: Предмет додано: ", item.item_name, " | Об’єкт: ", item.get_instance_id(), " | Інвентар: ", inv_node.get_instance_id(), " | Item: ", inv_node.Item)

func update_inventory_slots():
	for s in slot:
		s.item = null
		s.count = 0
		s.modulate = Color.WHITE

	if inv_node:
		var i = 0
		for key in inv_node.Item.keys():
			var entry = inv_node.Item[key]
			if entry.has("item") and i < slot.size():
				slot[i].item = entry["item"]
				slot[i].count = entry["count"]
				slot[i].modulate = Color.WHITE  
				print("Слот UI ", i, ": item_name = ", entry["item"].item_name, " | count = ", entry["count"])
				i += 1


func get_weapon_in_slot():
	return weapon_slot.item if weapon_slot.item != null and weapon_slot.item.is_in_group("weapon") else null

func _on_place_mode_button_pressed() -> void:
	print("Натиснута кнопка побудови")
	emit_signal("build_button_pressed")

func get_inventory() -> Inventory:
	return inv_node
