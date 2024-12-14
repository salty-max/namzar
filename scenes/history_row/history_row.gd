class_name HistoryRow
extends MarginContainer

signal animation_started
signal animation_finished

@onready var response: RichTextLabel = %Response
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_text_animated: bool
var animation_speed: float = 0.05
var delay: float = 0.0


func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_finished)


func set_text(cmd: String, res: String) -> void:
	if not is_node_ready():
		await ready

	%Feedback.text = cmd

	if is_text_animated:
		_start_typewriter(res)
	else:
		response.text = res


func _start_typewriter(text: String) -> void:
	response.text = text

	# Remove bbcode from text
	var regex = RegEx.new()
	regex.compile(r"\[\/?[a-zA-Z0-9_=#:; ]+\]")
	var raw_text = regex.sub(text, "", true)

	var duration: float = raw_text.length() * animation_speed
	var animation := animation_player.get_animation("typewriter")

	animation.length = duration
	animation.track_set_key_time(0, 1, duration)
	animation_started.emit()
	animation_player.play("typewriter")


func _on_animation_finished(_animation_name: String) -> void:
	animation_finished.emit()
