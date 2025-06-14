extends Resource
class_name Item

@export var texture: Texture2D
@export var name: String
@export var description: String

@export_enum("Tools", "Material", "Food", "Gun")
var type = "Material"
@export var is_stackable: bool = true
@export var item_name: String = ""
@export var item_type: String = ""
