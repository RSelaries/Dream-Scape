class_name ConsoleAnimated
extends Control


signal console_animation_has_ended


@export var total_outputs: ConsoleTotalOutput

@onready var console: RichTextLabel = %Console
@onready var outputs: Array[ConsoleOutput] = total_outputs.outputs


var current_output: int = 0:
	set(value):
		if value >= outputs.size():
			value = 0
			current_output = value
			console_animation_has_ended.emit()
		else:
			current_output = value
			_update_text_anim()


func _ready() -> void:
	console.text = ""


func _update_text_anim() -> void:
	var lines := outputs[current_output].text.split("\n")
	
	await get_tree().create_timer(outputs[current_output].display_wait).timeout
	
	for line in lines:
		console.text += line
		console.text += "\n"
		await get_tree().create_timer(outputs[current_output].line_wait).timeout
	
	current_output += 1
	
	#console.set_
