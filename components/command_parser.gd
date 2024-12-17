class_name CommandParser
extends Node

class Command:
	var cmd: String
	var args: int
	var description: String

	func _init(_cmd: String, _args: int, _description: String) -> void:
		self.cmd = _cmd
		self.args = _args
		self.description = _description

	func _to_string() -> String:
		return "%s\t\t%s" % [Palette.to_command(cmd), description]


var commands: Array[Command] = [
	Command.new("go", 1, "<direction> Move to another location"),
	Command.new("look", 0, "Examine current location"),
	Command.new("search", 0, "Search for objects at the current location"),
	Command.new("take", 1, "<item> Add an item to your inventory"),
	Command.new("drop", 1, "<item> Remove an item from your inventory"),
	Command.new("use", 1, "<item> Use an item"),
	Command.new("help", 0, "List available commands")
]

@onready var player: Player = %Player

var current_room: Room


func init(starting_room: Room) -> String:
	return _change_room(starting_room)


func parse_command(input: String) -> String:
	var words = input.to_lower().split(" ", false)
	if words.is_empty():
		return Palette.to_error("Empty command...")

	var cmd: String = words[0]
	var command = _get_command(cmd)
	if not command:
		return Palette.to_error("Unknown command: %s" % [cmd])

	var args = words.slice(1)

	match command.cmd:
		"go":
			return _go(args)
		"look":
			return _look()
		"search":
			return _search()
		"take":
			return _take(args)
		"drop":
			return _drop(args)
		"use":
			return _use(args)
		"inventory":
			return _inventory()
		"help":
			return _help()

	return Palette.to_error("Wololo!")


func _get_command(cmd: String) -> Command:
	for c: Command in commands:
		if c.cmd == cmd:
			return c
	return null


func _go(args: Array) -> String:
	if args.is_empty():
		return "Go where?"

	var dir = args[0]

	if current_room.exits.keys().has(dir):
		var exit = current_room.exits[dir] as Exit
		if exit.is_locked():
			return exit.get_locked_message()
		var room_change_string = _change_room(exit.get_next_room(current_room))
		return "\n\n".join([
			"You go %s" % Palette.to_direction(dir),
			room_change_string
		])

	return Palette.to_error("No exit in that direction.")


func _look() -> String:
	return current_room.get_description()


func _search() -> String:
	return current_room.get_search()


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


func _use(args: Array) -> String:
	if args.is_empty():
		return "Use what?"

	var item_name = " ".join(args)
	for item: Item in player.get_items():
		if item.name.to_lower() == item_name:
			match item.type:
				Item.ItemType.KEY:
					var used = false
					for exit: Exit in current_room.exits.values():
						if exit.get_key() == item:
							exit.unlock()
							used = true
							return "You use %s to unlock the way to %s." % [Palette.to_item(item_name), Palette.to_room(exit.get_next_room(current_room).room_name)]
					if not used:
						return "No use for %s here." % Palette.to_item(item_name)
				_:
					printerr("_use: invalid item type")
					return ""

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
		"\n".join(commands.map(func(c: Command): return "\t- %s" % c))
	])


func _change_room(new_room: Room) -> String:
	current_room = new_room
	var location = current_room.get_location()
	if not current_room.visited:
		current_room.visited = true
	return location
