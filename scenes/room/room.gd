@tool
class_name Room
extends PanelContainer

@export var room_name: String : set = _set_room_name
@export_multiline var room_description: String: set = _set_room_description

@onready var room_name_label: Label = %RoomName
@onready var room_description_label: RichTextLabel = %RoomDescription

@export var exits: Dictionary = {}


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


func connect_exit(direction: String, room: Room) -> void:
	match direction:
		"west":
			exits[direction] = room
			room.exits["east"] = self
		"east":
			exits[direction] = room
			room.exits["west"] = self
		"north":
			exits[direction] = room
			room.exits["south"] = self
		"south":
			exits[direction] = room
			room.exits["north"] = self
		_:
			printerr("Failed to connect invalid direction: %s", direction)
