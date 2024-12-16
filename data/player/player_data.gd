class_name PlayerData
extends Resource

@export var name: StringName : set = _set_name
@export var gold: int : set = _set_gold
@export var items: Array[Item]


func _set_name(value: String) -> void:
	name = value
	emit_changed()


func _set_gold(value: int) -> void:
	gold = value
	emit_changed()


func add_item(value: Item) -> void:
	items.append(value)
	emit_changed()


func remove_item(value: Item) -> void:
	items.erase(value)
	emit_changed()


func _to_string() -> String:
	return "".join([
		"Name: %s\n" % name,
		"Gold: %s\n" % gold,
		"Items:\n",
		"\n".join(items.map(func(item: Item): return "\t- %s" % item.name))
	])
