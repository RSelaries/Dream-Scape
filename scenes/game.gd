class_name SceneManager
extends Node


@export var awake_scene: Scene
@export var packed_scenes: Dictionary[String, PackedScene] = {
	"AwakeScene": preload("res://scenes/awake/awake_scene.tscn"),
	"AsleepScene": preload("res://scenes/asleep/asleep_scene.tscn"),
}


var current_scene: String = "AwakeScene"


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	awake_scene.cinematic_player.play("starting_cinematic")


## The property [code]scene_name[/code] is in PascalCase [br]
## So [code]asleep_scene[/code] would be [code]AsleepScene[/code]
func switch_scene(scene_name: String = "AsleepScene") -> void:
	find_child(current_scene).queue_free()
	
	var new_scene: Scene = packed_scenes[scene_name].instantiate()
	
	add_child(new_scene)
	current_scene = scene_name


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("screenshot"):
		_take_screenshot()


func _take_screenshot() -> void:
	await RenderingServer.frame_post_draw
		
	var img := get_viewport().get_texture().get_image()
	var screenshot_name: String = ""
	for character in Time.get_datetime_string_from_system():
		if character == ":":
			character = "-"
		screenshot_name += character
	img.save_png("E:/Godot/Screenshots/" + screenshot_name + ".png")
