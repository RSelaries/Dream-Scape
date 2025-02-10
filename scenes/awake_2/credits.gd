extends Control


@onready var credits_rich_label: RichTextLabel = %CreditsRichLabel


func _ready() -> void:
	credits_rich_label.position.y = DisplayServer.screen_get_size().y


func _scroll_credits() -> void:
	var tween := get_tree().create_tween()
	
	tween.tween_property(credits_rich_label, "position", Vector2(0, - credits_rich_label.size.y), 20)
