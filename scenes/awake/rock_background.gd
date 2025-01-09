extends Node3D


var speed := 1.0


func _process(delta: float) -> void:
	for child in get_children():
		if child is MeshInstance3D:
			var child_mesh: MeshInstance3D = child
			if child_mesh.get_active_material(0):
				var child_material: StandardMaterial3D = child_mesh.get_active_material(0)
				child_material.uv1_offset.z += speed * delta
			
