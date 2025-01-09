extends InteractibleObject3D


@onready var interact_infos: CanvasLayer = $InteractInfos
@onready var inputs_textures: CanvasLayer = $InputsTextures


func _ready() -> void:
	interact_infos.visible = false
	inputs_textures.visible = false


func _process(_delta: float) -> void:
	super(_delta)
	inputs_textures.visible = inspected


func _inspect_interact_2() -> void:
	interact_infos.visible = !interact_infos.visible


func _on_return() -> void:
	interact_infos.visible = false
	inputs_textures.visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("return"):
		interact_infos.visible = false
	
	if interact_infos.visible:
		if event.is_action_pressed("mouse_wheel_up") or event.is_action_pressed("mouse_wheel_down"):
			get_viewport().set_input_as_handled()
