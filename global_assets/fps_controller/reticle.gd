extends CenterContainer
class_name Reticle

enum ReticleTypes {CIRCLE, HAND, CLOSED_HAND, VISOR, NONE, SLEEP}

@export var reticle_type: ReticleTypes = ReticleTypes.CIRCLE

@export_group("Draw Parameters")
@export var line_width : float = 1.5
@export var line_length : float = 12.0
@export var line_color : Color = Color.WHITE
@export var offset : float = 10.0

@onready var hand_reticle: TextureRect = %HandReticle
@onready var closed_hand_reticle: TextureRect = %ClosedHandReticle
@onready var sleep_reticle: TextureRect = %SleepReticle


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	var center := size * 0.5
	
	_hide_children()
	
	match reticle_type:
		ReticleTypes.CIRCLE:
			draw_circle(center, line_width * 0.75, line_color, true)
			
		ReticleTypes.VISOR:
			draw_line(center + Vector2(offset, 0), center + Vector2(offset + line_length, 0), line_color, line_width)
			draw_line(center + Vector2(-offset, 0), center + Vector2(-offset + -line_length, 0), line_color, line_width)
			draw_line(center + Vector2(0, offset), center + Vector2(0, offset + line_length), line_color, line_width)
			draw_line(center + Vector2(0, -offset), center + Vector2(0, -offset + -line_length), line_color, line_width)
			
		ReticleTypes.HAND:
			hand_reticle.visible = true
		
		ReticleTypes.CLOSED_HAND:
			closed_hand_reticle.visible = true
		
		ReticleTypes.SLEEP:
			sleep_reticle.visible = true
		
		ReticleTypes.NONE:
			pass


func _hide_children() -> void:
	for child in get_children():
		if child is Node2D or child is Node3D or child is Control:
			@warning_ignore("unsafe_property_access")
			child.visible = false


func fade_out(fade_time: float) -> void:
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "line_color", Color(line_color.r, line_color.g, line_color.b, 0), fade_time)

func fade_in(fade_time: float) -> void:
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "line_color", Color(line_color.r, line_color.g, line_color.b, 1), fade_time)
