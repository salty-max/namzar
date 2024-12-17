class_name Game
extends Control

signal intro_finished

const OUTPUT := preload("res://scenes/output/output.tscn")
const INPUT_RESPONSE := preload("res://scenes/input_response/input_response.tscn")
const MUSIC := preload("res://assets/audio/STILES - Ammo Count- 00.mp3")

@export var animated_text: bool = true
@export var text_scroll_speed: float = 1.0
@export var max_history_length: int = 30
@export var hide_intro: bool = false

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

	intro_finished.connect(_on_intro_finished)

	if not hide_intro:
		start_intro()


func start_intro() -> void:
	_create_output("Once, you strode boldly into the lair of Namzar the Malevolent, armed with the unshakable confidence of someone who has no idea what they’re doing. It… did not go well.\n\nAnd now, you awaken here. Where is here? A charming little shed held together by hope and splinters. How did you get here? Even I don’t know. But one thing is certain: Namzar is still out there, likely gloating.\n\nWell, let’s not dwell on the past or the embarrassing defeat. What’s your name again?")


func _process_player_name(input: String) -> void:
	if input.is_empty():
		_create_output(Palette.to_error("You surely have a name!"))
		return

	player.data.name = input
	_create_input_response(input, "Ah, %s. A name destined for greatness, assuming you can avoid repeating the last fiasco. Now then, let’s figure out how to get you back on your feet, and maybe a bit more prepared this time." % Palette.to_character(input))
	intro_finished.emit()


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
	if hide_intro:
		_process_input(new_text)
	else:
		_process_player_name(new_text)


func _on_scroll_bar_changed() -> void:
	if max_scroll_length != scroll_bar.max_value:
		max_scroll_length = scroll_bar.max_value
		scroll.scroll_vertical = ceil(scroll_bar.max_value)


func _on_text_scroll_started() -> void:
	text_input.editable = false


func _on_text_scroll_finished() -> void:
	text_input.editable = true


func _on_intro_finished() -> void:
	hide_intro = true
	if animated_text:
		await get_tree().create_timer(3.0).timeout
	_create_output(command_parser.init(room_manager.get_child(0)))
