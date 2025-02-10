class_name AsleepScene
extends Scene


@onready var glitch_node: ColorRect = %Glitch
@onready var glitch_shader: ShaderMaterial = glitch_node.get_material()
@onready var console_animated: ConsoleAnimated = %ConsoleAnimated

@export var change_scene: bool = false:
	set(value):
		change_scene = false
		_change_scene_to_awake_2()


var glitched := false


func _ready() -> void:
	super()
	
	cinematic_player.play("starting_cinematic")
	console_animated.console_animation_has_ended.connect(_change_scene_to_awake_2)


func _handle_glitch() -> void:
	cinematic_player.play("glitch")


func _on_near_walls_area_body_entered(body: Node3D) -> void:
	if body is FpsPlayer and !glitched:
		_handle_glitch()
		glitched = true


func _change_scene_to_awake_2() -> void:
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/awake_2/awake_scene_2.tscn")
	
