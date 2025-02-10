class_name AsleepScene
extends Scene


@onready var glitch_node: ColorRect = %Glitch
@onready var glitch_shader: ShaderMaterial = glitch_node.get_material()


func _ready() -> void:
	super()
	
	cinematic_player.play("starting_cinematic")


func _handle_glitch() -> void:
	# ==== Glitch Shader ====
	cinematic_player.play("glitch")
	# =======================
	pass


func _on_glitching_timer_timeout() -> void:
	pass
	
