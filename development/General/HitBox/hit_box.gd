class_name HitBox extends Area2D

signal hit(damage: int)

func _take_hit(_damage: int) -> void:
	hit.emit(_damage)
