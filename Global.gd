extends Node


signal game_state_changed(game_state: GameStates)


const opened_hand := preload("res://global_assets/textures/hand_reticle.png")
const closed_hand := preload("res://global_assets/textures/closed_hand_reticle.png")

enum GameStates {PLAYING, CINEMATIC, OBJECT_INSPECTING}

var current_game_state := GameStates.PLAYING:
	set(value):
		current_game_state = value
		game_state_changed.emit(value)
var player: FpsPlayer


func _ready() -> void:
	game_state_changed.connect(_on_game_state_changed)


func _on_game_state_changed(game_state: GameStates) -> void:
	match game_state:
		GameStates.PLAYING:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			Input.set_custom_mouse_cursor(null)
		
		GameStates.OBJECT_INSPECTING:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			Input.set_custom_mouse_cursor(opened_hand)
			Input.warp_mouse(get_window().size * 0.5 - Vector2(8, 8))
		
		GameStates.CINEMATIC:
			pass


func _unhandled_input(event: InputEvent) -> void:
	if current_game_state == GameStates.OBJECT_INSPECTING:
		if event.is_action_pressed("interact"):
			Input.set_custom_mouse_cursor(closed_hand)
		elif event.is_action_released("interact"):
			Input.set_custom_mouse_cursor(opened_hand)
