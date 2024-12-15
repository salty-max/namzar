class_name InputResponse
extends VBoxContainer

@onready var output: Output = %Output

var is_text_animated: bool
var text_scroll_speed: float = 0.05


func set_text(cmd: String, res: String) -> void:
	if not is_node_ready():
		await ready

	%Feedback.text = cmd

	output.is_text_animated = is_text_animated
	output.text_scroll_speed = text_scroll_speed
	output.display(res)
