@tool
class_name TalkableCharacter3D
extends InteractibleObject3D


@export var animation_player: AnimationPlayer
@export var base_animation: String = "sat"
@export var speech: Array[Speech]
@export var speech_bubble_sprite: SpeechBubble3D


@onready var next_speech_timer: Timer


var current_speech: int = -1:
	set(value):
		if value >= speech.size():
			value = -1
		
		if value == -1:
			speech_bubble_sprite.speech = ""
		else:
			speech_bubble_sprite.next_char_time = speech[value].next_char_time
			speech_bubble_sprite.speech = speech[value].text
			next_speech_timer.wait_time = speech[value].next_speech_time
		
		current_speech = value


func _ready() -> void:
	if Engine.is_editor_hint() and animation_player:
		animation_player.play(base_animation)
		return
	
	next_speech_timer = Timer.new()
	next_speech_timer.timeout.connect(_on_next_speech_timer_timeout)
	next_speech_timer.one_shot = true
	add_child(next_speech_timer)
	
	speech_bubble_sprite.speech_ended.connect(func() -> void:
		if current_speech != -1:
			next_speech_timer.start()
	)
	
	animation_player.play(base_animation)
	interaction_type = InteractionTypes.TALK


func interact() -> void:
	current_speech += 1


func _on_next_speech_timer_timeout() -> void:
	current_speech += 1
