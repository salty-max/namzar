@tool
class_name Room
extends PanelContainer

@export var room_name: String : set = _set_room_name
@export_multiline var room_description: String: set = _set_room_description
@export var exits: Dictionary = {}
@export var items: Array[Item] = []
@export var visited: bool = false

@onready var room_name_label: Label = %RoomName
@onready var room_description_label: RichTextLabel = %RoomDescription


func _ready() -> void:
	room_name_label.text = room_name
	room_description_label.text = room_description


func _set_room_name(value: String) -> void:
	if not is_node_ready():
		await ready

	room_name = value
	room_name_label.text = room_name


func _set_room_description(value: String) -> void:
	if not is_node_ready():
		await ready

	room_description = value
	room_description_label.text = room_description


func get_location() -> String:
	var msg = "You are back in %s." if visited else "You are now in %s."
	return msg % Palette.to_room(room_name)


func get_description() -> String:
	var description = "\n\n".join([
		room_description,
		get_items(),
		get_exits()
	])

	return description


func get_items() -> String:
	if items.is_empty():
		return "No items to pick up."

	return "Items: %s" % ", ".join(items.map(
		func(item: Item):
			return Palette.to_item(item.name)
	))


func get_exits() -> String:
	return "Exits: %s" % Palette.to_direction(" ".join(exits.keys()))


func connect_exit(direction: String, room: Room) -> void:
	var exit := Exit.new()
	exit.room_1 = self
	exit.room_2 = room
	exits[direction] = exit
	match direction:
		"west":
			room.exits["east"] = exit
		"east":
			room.exits["west"] = exit
		"north":
			room.exits["south"] = exit
		"south":
			room.exits["north"] = exit
		_:
			printerr("Failed to connect invalid direction: %s", direction)


func add_item(item: Item) -> void:
	items.append(item)


func remove_item(item) -> void:
	items.erase(item)
