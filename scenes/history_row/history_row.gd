class_name HistoryRow
extends MarginContainer

@export var animation_speed: float = 2.0

@onready var response: RichTextLabel = %Response

var final_text: String
var current_char_index: int = 0
var character_delay: float = 0.0
var elapsed_time: float = 0.0
var is_typing: bool = false


func set_text(cmd: String, res: String) -> void:
	if not is_node_ready():
		await ready

	%Feedback.text = cmd
	_start_typewriter(res)


func _start_typewriter(text: String) -> void:
	final_text = text
	current_char_index = 0
	elapsed_time = 0.0
	is_typing = true
	character_delay = animation_speed / max(final_text.length(), 1)
	response.clear()


func _process(delta: float) -> void:
	if is_typing:
		elapsed_time += delta

		while elapsed_time >= character_delay and current_char_index < final_text.length():
			# Add the next character to the label
			response.append_text(final_text[current_char_index])
			current_char_index += 1
			elapsed_time -= character_delay

		if current_char_index >= final_text.length():
			is_typing = false
