extends Node


@export var awake_scene: Scene


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	awake_scene.cinematic_player.play("starting_cinematic")
