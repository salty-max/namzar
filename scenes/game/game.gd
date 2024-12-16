class_name Game
extends Control

const OUTPUT := preload("res://scenes/output/output.tscn")
const INPUT_RESPONSE := preload("res://scenes/input_response/input_response.tscn")
const MUSIC := preload("res://assets/audio/STILES - Ammo Count- 00.mp3")

@export var animated_text: bool = true
@export var text_scroll_speed: float = 1.0
@export var max_history_length: int = 30
@export var intro_finished: bool = false

@onready var player: Player = %Player
@onready var room_manager: RoomManager = $RoomManager
@onready var command_parser: CommandParser = $CommandParser
@onready var history: VBoxContainer = %History
@onready var scroll: ScrollContainer = %Scroll
@onready var scroll_bar: VScrollBar = %Scroll.get_v_scroll_bar()
@onready var text_input: TextInput = %TextInput

var max_scroll_length := 0.0



func _ready() -> void:
	scroll_bar.changed.connect(_on_scroll_bar_changed)
	max_scroll_length = scroll_bar.max_value
	MusicPlayer.play(MUSIC)

	if animated_text:
		EventBus.text_scroll_started.connect(_on_text_scroll_started)
		EventBus.text_scroll_finished.connect(_on_text_scroll_finished)

	_create_output("Welcome to Namzar! Type %s to list available commands" % Palette.colorize("help", Palette.PaletteColor.BLUE))
	await get_tree().create_timer(2.0).timeout
	if not intro_finished:
		start_intro()
	command_parser.init(room_manager.get_child(0))


func start_intro() -> void:
	_create_output("You wake up lying on the creaky floor of what might generously be called a shack. The walls, made of wood that has clearly lost the will to live, lean at odd angles, letting the cold air poke through every gap. A single broken plank dangles ominously, as if it might fall just to spite you.\nThe smell? Imagine a mix of wet socks and regret.\n\nYour head feels like it is stuffed with dungeon moss, and you can’t quite remember how you got here. Still, priorities first: escape. But before you do anything heroic or foolish, you should probably figure out what to call yourself.\n\nSo… what’s your name?")


func _process_player_name(input: String) -> void:
	if input.is_empty():
		_create_output(Palette.to_error("You surely have a name!"))
		return

	player.data.name = input
	_create_input_response(input, "Ok %s, now it is time to get out of here." % input)
	intro_finished = true


func _process_input(input: String) -> void:
	if input.is_empty():
		return

	var res := command_parser.parse_command(input)
	_create_input_response(input ,res)


func _create_output(text: String) -> void:
	var output := OUTPUT.instantiate()
	output.is_text_animated = animated_text
	output.text_scroll_speed = text_scroll_speed
	output.display(text)
	history.add_child(output)
	_delete_old_history()

func _create_input_response(input: String, res: String) -> void:
	var response := INPUT_RESPONSE.instantiate()

	response.is_text_animated = animated_text
	response.text_scroll_speed = text_scroll_speed
	response.set_text(input, res)
	history.add_child(response)
	_delete_old_history()


func _delete_old_history() -> void:
	if history.get_child_count() >= max_history_length:
		var rows_to_forget := history.get_child_count() - max_history_length
		for i in range(rows_to_forget):
			history.get_child(i).queue_free()


func _on_text_input_text_submitted(new_text: String) -> void:
	if intro_finished:
		_process_input(new_text)
	else:
		_process_player_name(new_text)


func _on_scroll_bar_changed() -> void:
	if max_scroll_length != scroll_bar.max_value:
		max_scroll_length = scroll_bar.max_value
		scroll.scroll_vertical = scroll_bar.max_value


func _on_text_scroll_started() -> void:
	text_input.editable = false


func _on_text_scroll_finished() -> void:
	text_input.editable = true
