@tool
class_name Platform extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

enum TYPE {Grass, Sand, Lava, Ice}
enum WIDTH {Narrow, Wide}

@export var width: WIDTH = WIDTH.Wide :
	set(_v):
		width = _v
		_update_sprite()
		
@export var type: TYPE = TYPE.Grass :
	set(_v):
		type = _v
		_update_sprite()
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_sprite()



func _update_sprite() -> void:
	sprite.region_rect.size.x = 16 * (width + 1)
	sprite.region_rect.position.x = 0 if width==0 else 16
	sprite.region_rect.position.y = (type + 1) * 16 - 16
