@tool
extends Node3D


@export var lights_values := {
	"range": 5.0,
	"attenuation": 1.0,
	"color": Color.WHITE,
	"energy": 1.0,
	"indirect_energy": 1.0,
}:
	set(value):
		lights_values = value
		_update_lights()


var lights: Array[SpotLight3D]


func _ready() -> void:
	_update_lights()


func _update_lights() -> void:
	for child: Node3D in get_children():
		for child_child in child.get_children():
			if child_child is Light3D:
				lights.append(child_child)
	
	for light in lights:
		light.spot_range = lights_values.range
		light.spot_attenuation = lights_values.attenuation
		light.light_color = lights_values.color
		light.light_energy = lights_values.energy
		light.light_indirect_energy = lights_values.indirect_energy
