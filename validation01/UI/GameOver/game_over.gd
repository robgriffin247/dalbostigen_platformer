extends CanvasLayer

@onready var retry_button: Button = $Control/RetryButton

func _ready() -> void:
	hide()
	retry_button.pressed.connect(_reload_level)

func _reload_level() -> void:
	hide()
	get_tree().reload_current_scene()
