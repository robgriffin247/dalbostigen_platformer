class_name HurtBox extends Area2D

@export var damage_effect : int = 1

func _ready() -> void:
	area_entered.connect(_area_entered)

func _area_entered( _area: Area2D) -> void:
	if _area is HitBox:
		_area._take_hit(damage_effect)
