extends CanvasLayer

@onready var inventory_panel := $Inventory
@onready var toggle_button := $ToggleButton
@onready var weapon_slot := $WeaponSlot/slot  
@onready var place_button = $PlaceModeButton
var slot: Array = []
var inventory_open := false
var inv_node: Inventory = null

func _ready():
	inventory_panel.visible = false
	toggle_button.pressed.connect(_on_toggle_button_pressed)

	# Додаємо всі слоти
	for i in $hotbar.get_children():
		slot.append(i)
	for i in $Inventory.get_children():
		slot.append(i)

	inv_node = get_node("Node")
	if inv_node:
		inv_node.item_added.connect(_on_item_added)
		update_inventory_slots()

func _on_toggle_button_pressed() -> void:
	_toggle_inventory()

func _toggle_inventory():
	inventory_open = not inventory_open
	inventory_panel.visible = inventory_open

func _on_item_added(item: Item):
	update_inventory_slots()

func update_inventory_slots():
	for s in slot:
		s.item = null
		s.count = 0

	if inv_node:
		var i = 0
		for key in inv_node.Item.keys():
			var entry = inv_node.Item[key]
			if entry.has("item") and i < slot.size():
				slot[i].item = entry["item"]
				slot[i].count = entry["count"]
				i += 1

# Перевірка чи є зброя в слоті
func get_weapon_in_slot():
	return weapon_slot.item if weapon_slot.item != null and weapon_slot.item.is_in_group("weapon") else null

signal build_button_pressed
func _on_place_mode_button_pressed() -> void:
	print("Натиснута кнопка побудови")
	emit_signal("build_button_pressed")
