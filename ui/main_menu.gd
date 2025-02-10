extends Control


@export var game_scene: PackedScene

@onready var animation_player: AnimationPlayer = %AnimationPlayer

@onready var play_button: Button = %PlayButton
@onready var options_button: Button = %OptionsButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	if not Engine.is_embedded_in_editor():
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_play_button_pressed() -> void:
	play_button.focus_mode = Control.FOCUS_NONE
	animation_player.play("play_animation")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "play_animation":
		get_tree().change_scene_to_packed(game_scene)


func _capture_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
