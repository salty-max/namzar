class_name Item
extends Resource

enum ItemType {
	KEY,
}

@export var name: StringName
@export var type: ItemType


func _init(_name: StringName, _type: ItemType) -> void:
	self.name = _name
	self.type = _type
