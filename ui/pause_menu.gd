extends Control


func _ready() -> void:
	visible = false


func _on_reload_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		visible = !visible
		
		if visible == false:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_resume_button_pressed() -> void:
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
