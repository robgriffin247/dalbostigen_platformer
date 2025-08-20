extends CanvasLayer

@onready var retry_button: Button = $Control/RetryButton

func _ready() -> void:
	visible = false
	retry_button.pressed.connect(_reload_level)


func _reload_level() -> void:
	get_tree().reload_current_scene()
	visible = false
