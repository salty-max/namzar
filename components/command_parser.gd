class_name CommandParser
extends Node

const COMMAND_DEFS := {
	"go": 2,
	"back": 1,
	"attack": 4,
	"help": 1
}


func parse_command(input: String) -> String:
	var words = input.to_lower().split(" ", false)
	if words.is_empty():
		return "Empty command..."

	var cmd: String = words[0]
	if not COMMAND_DEFS.has(cmd):
		return "Unknown command: %s" % [cmd]

	var expected_args_count = COMMAND_DEFS[cmd] - 1
	var args = words.slice(1)

	match cmd:
		"go":
			return _go(args)
		"help":
			return _help()

	return '[color="#ff0000"]Wololo![/color]'


func _go(args: Array) -> String:
	if args.is_empty():
		return "Go where?"

	return "You go %s" % args[0]


func _help() -> String:
	return 'Available commands:\n- [color="#89b4fa"]go[/color] <location>\n- [color="#89b4fa"]help[/color]'
