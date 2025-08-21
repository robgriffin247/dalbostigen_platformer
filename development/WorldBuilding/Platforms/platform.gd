@tool
class_name Platform extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var _width: int

enum TYPE {Grass, Sand, Lava, Ice}
enum WIDTH {Narrow, Wide}

@export var width: WIDTH = WIDTH.Wide :
	set(_v):
		width = _v
		_update_platform_width()
		
@export var type: TYPE = TYPE.Grass :
	set(_v):
		type = _v
		_update_platform_type()


func _ready() -> void:
	_update_platform_width()
	_update_platform_type()
	

func _update_platform_width() -> void:
	var _width = 16 * (width + 1)
	
	if collision_shape:
		collision_shape.shape.set_size(Vector2(_width, 9))
	
	if sprite:
		sprite.region_rect.size.x = _width
		sprite.region_rect.position.x = 0 if width == 0 else 16


func _update_platform_type() -> void:
	if sprite:
		sprite.region_rect.position.y = (type + 1) * 16 - 16
