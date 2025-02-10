extends MeshInstance3D


@export var slide_speed := 0.5

@onready var material: StandardMaterial3D = get_active_material(0)


func _process(delta: float) -> void:
	material.uv1_offset += Vector3(slide_speed * delta, slide_speed * delta, 0)
