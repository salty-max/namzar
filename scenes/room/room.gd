@tool
class_name Room
extends PanelContainer

const DIRECTION_OPPOSITES := {
	"north": "south",
	"south": "north",
	"east": "west",
	"west": "east",
	"inside": "outside",
	"outside": "inside",
	"path": "path"
}

@export var room_name: String : set = _set_room_name
@export_multiline var room_description: String: set = _set_room_description
@export_multiline var room_search: String = ""
@export var prefix: String = ""
var exits: Dictionary = {}
var items: Array[Item] = []
var visited: bool = false

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
	var msg = "You are back %s%s." if visited else "You are now %s%s."
	var location_prefix := "%s " % prefix if not prefix.is_empty() else ""
	return msg % [location_prefix, Palette.to_room(room_name)]


func get_description() -> String:
	return room_description


func get_search() -> String:
	return room_search if not room_search.is_empty() else "Nothing of interest here."


func get_items() -> String:
	if items.is_empty():
		return "No items to pick up."

	return "Items: %s" % ", ".join(items.map(
		func(item: Item):
			return Palette.to_item(item.name)
	))


func get_exits() -> String:
	return "Exits: %s" % Palette.to_direction(" ".join(exits.keys()))


func connect_exit_unlocked(direction: String, room: Room, room_b_exit_override: String = "") -> void:
	_connect_exit(direction, room, false, null, "", room_b_exit_override)


func connect_exit_locked(direction: String, room: Room, key: Item, locked_msg: String = "", room_b_exit_override: String = "") -> void:
	_connect_exit(direction, room, true, key, locked_msg, room_b_exit_override)


func _connect_exit(direction: String, room: Room, locked: bool = false,  key: Item = null, locked_msg: String = "", room_b_exit_override: String = "") -> void:
	if not DIRECTION_OPPOSITES.has(direction) and room_b_exit_override.is_empty():
		printerr("Failed to connect invalid direction: %s" % direction)
		return

	var exit := Exit.new(
		self,
		room,
		locked,
		key,
		"Locked." if locked_msg.is_empty() else locked_msg,
	)
	exits[direction] = exit

	var reverse_direction = room_b_exit_override if not room_b_exit_override.is_empty() else DIRECTION_OPPOSITES[direction]
	room.exits[reverse_direction] = exit


func add_item(item: Item) -> void:
	items.append(item)


func remove_item(item) -> void:
	items.erase(item)
