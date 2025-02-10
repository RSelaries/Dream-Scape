class_name AsleepScene
extends Scene


@onready var glitch_node: ColorRect = %Glitch
@onready var glitch_shader: ShaderMaterial = glitch_node.get_material()


var glitched := false


func _ready() -> void:
	super()
	
	cinematic_player.play("starting_cinematic")


func _handle_glitch() -> void:
	cinematic_player.play("glitch")


func _on_near_walls_area_body_entered(body: Node3D) -> void:
	if body is FpsPlayer and !glitched:
		_handle_glitch()
		glitched = true
