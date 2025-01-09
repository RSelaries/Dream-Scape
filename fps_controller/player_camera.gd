class_name PlayerCamera
extends Camera3D


@export_subgroup("Shaking")
@export var shake_intensity: float = 1
@export var shake_noise_scale : float = 0.94
@export_subgroup("Oscilation")
@export var shake_oscillation_speed: float = 2
@export var shake_oscillation_amplitude: float = 0.3
@export_subgroup("Viewbobbing")
@export var viewbobbing_frequency: float
@export var viewbobbing_force: float

var shake_oscillation_timer: float = 0.0
var original_position: Vector3
var viewbobbing_timer: float = 0.0

@onready var noise := FastNoiseLite.new()
@onready var _owner : CharacterBody3D = owner


func _ready() -> void:
	original_position = self.position
	#noise.seed = int(randf() * 10000)


func _process(delta: float) -> void:
	position = original_position
	_apply_shake(delta)
	_apply_oscillation(delta)
	_apply_viewbobbing(delta)


func _apply_shake(delta: float) -> void:
	# Génère des secousses basées sur le bruit
	var shake_x := noise.get_noise_2d(Engine.get_physics_frames() * shake_noise_scale, 0) * shake_intensity * delta
	var shake_y := noise.get_noise_2d(0, Engine.get_physics_frames() * shake_noise_scale) * shake_intensity * delta
	translate_object_local(Vector3(shake_x, shake_y, 0))


func _apply_oscillation(delta: float) -> void:
	# Ajoute une oscillation périodique pour imiter le roulis
	shake_oscillation_timer += delta
	var roll_angle := sin(shake_oscillation_timer * shake_oscillation_speed) * shake_oscillation_amplitude
	rotation_degrees.z = roll_angle


func _apply_viewbobbing(delta: float) -> void:
	viewbobbing_timer += delta
	if _owner.velocity == Vector3.ZERO:
		viewbobbing_timer = 0
	
	var vel : Vector3 = _owner.velocity
	
	vel.y = 0
	var velMag := vel.length()
	
	var bobbing_oscilation: float = sin(velMag * (2 * PI) * viewbobbing_timer * viewbobbing_frequency) * viewbobbing_force
	
	position.y += bobbing_oscilation
