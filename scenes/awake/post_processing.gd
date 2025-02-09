@tool
extends Node


@export_tool_button("Toggle Post Processing")
var toggle := func()-> void:
	for child in get_children():
		if child is CanvasLayer:
			@warning_ignore("unsafe_property_access")
			child.visible = not child.visible
	
