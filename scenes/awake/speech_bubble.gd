class_name SpeechBubble3D
extends Node3D


signal speech_ended


@export var speech: String = "":
	set(value):
		speech = value
		if speech_label and ready_passed:
			_update_text()
@export var next_char_time: float = 0.02


@onready var speech_label: Label = %SpeechLabel
@onready var next_char_timer: Timer = %NextCharTimer


var ready_passed := false
var current_char: int = 0


func _ready() -> void:
	ready_passed = true


func _update_text() -> void:
	next_char_timer.stop()
	next_char_timer.wait_time = next_char_time
	
	speech_label.text = speech.substr(0, 1)
	current_char = 0
	
	next_char_timer.start()


func _on_next_char_timer_timeout() -> void:
	current_char += 1
	speech_label.text += speech.substr(current_char, 1)
	
	if not current_char >= speech.length() - 1:
		next_char_timer.start()
	else:
		speech_ended.emit()
