class_name CommandParser
extends Node

const COMMAND_DEFS := {
	"go": 2,
	"look": 1,
	"take": 2,
	"drop": 2,
	"inventory": 1,
	"help": 1,
}

@onready var player: Player = %Player

var current_room: Room


func init(starting_room: Room) -> void:
	current_room = starting_room


func parse_command(input: String) -> String:
	var words = input.to_lower().split(" ", false)
	if words.is_empty():
		return Palette.to_error("Empty command...")

	var cmd: String = words[0]
	if not COMMAND_DEFS.has(cmd):
		return Palette.to_error("Unknown command: %s" % [cmd])

	var args = words.slice(1)

	match cmd:
		"go":
			return _go(args)
		"look":
			return _look()
		"take":
			return _take(args)
		"drop":
			return _drop(args)
		"inventory":
			return _inventory()
		"help":
			return _help()

	return Palette.to_error("Wololo!")


func _go(args: Array) -> String:
	if args.is_empty():
		return "Go where?"

	var dir = args[0]

	if current_room.exits.keys().has(dir):
		var exit = current_room.exits[dir]
		var room_change_string = _change_room(exit.get_next_room(current_room))
		return "\n\n".join([
			"You go %s" % Palette.to_direction(dir),
			room_change_string
		])

	return Palette.to_error("No exit in that direction.")


func _look() -> String:
	return current_room.get_description()


func _take(args: Array) -> String:
	if args.is_empty():
		return "Take what?"

	var item_name = " ".join(args)

	for item: Item in current_room.items:
		if item.name.to_lower() == item_name:
			player.take_item(item)
			current_room.remove_item(item)
			return "You take the %s." % Palette.to_item(item_name)

	return "No %s found." % item_name


func _drop(args: Array) -> String:
	if args.is_empty():
		return "Drop what?"

	var item_name = " ".join(args)

	for item: Item in player.get_items():
		if item.name.to_lower() == item_name:
			player.drop_item(item)
			current_room.add_item(item)
			return "You drop the %s." % Palette.to_item(item_name)

	return "No %s in your possession." % item_name


func _inventory() -> String:
	if player.get_items().is_empty():
		return "You possess nothing at the moment."

	return "".join([
		"You possess:\n",
		"\n".join(player.get_items().map(
			func(item: Item):
				return "\t- %s" % Palette.to_item(item.name))
		)
	])


func _help() -> String:
	return "".join([
		"Available commands:\n",
		"\n".join(COMMAND_DEFS.keys().map(
			func(key: String):
				return "\t- %s" % Palette.to_command(key))
		)
	])


func _change_room(new_room: Room) -> String:
	current_room = new_room
	var location = current_room.get_location()
	if not current_room.visited:
		current_room.visited = true
	return location
