extends Node


signal game_state_changed(game_state: GameStates)


const opened_hand := preload("res://global_assets/textures/hand_reticle.png")
const closed_hand := preload("res://global_assets/textures/closed_hand_reticle.png")
const screenshot_path: String = "E:/Godot/Screenshots"

enum GameStates {PLAYING, CINEMATIC, OBJECT_INSPECTING}

var current_game_state := GameStates.PLAYING:
	set(value):
		current_game_state = value
		game_state_changed.emit(value)
var player: FpsPlayer


@onready var screenshot_nbr: int = _get_nbr_of_screenshots()


func _ready() -> void:
	game_state_changed.connect(_on_game_state_changed)
	
	print("there are : ", screenshot_nbr, " screenshots")


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
	
	if event.is_action_pressed("screenshot"):
		screenshot()


func _get_nbr_of_screenshots() -> int:
	var screenshot_folder: DirAccess = DirAccess.open(screenshot_path)
	
	var nbr: int = 0
	
	if screenshot_folder:
		screenshot_folder.list_dir_begin()
		var screenshot_file: String = screenshot_folder.get_next()
		while screenshot_file != "":
			nbr += 1
			screenshot_file = screenshot_folder.get_next()
	
	return nbr


func screenshot() -> void:
	await  RenderingServer.frame_post_draw
	
	var capture: Image = get_viewport().get_texture().get_image()	
	capture.save_png(screenshot_path + "/screenshot_%s.png" % screenshot_nbr)
	
	screenshot_nbr += 1
