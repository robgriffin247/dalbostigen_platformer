@tool
class_name Platform extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum TYPE {Grass, Sand, Lava, Ice}
enum WIDTH {Narrow, Wide}

@export var width: WIDTH = WIDTH.Wide :
	set(_v):
		width = _v
		_update_width()


@export var type: TYPE = TYPE.Grass :
	set(_v):
		type = _v
		_update_type()

@export var standardise_speed: bool = true
@export_range(1, 100, 1, "or_greater") var speed: int = 50

func _ready() -> void:
	_update_width()
	_update_type()
	_standardise_speed()

func _update_width() -> void:
	var _width = 16 * (width + 1)
	
	if collision_shape:
		collision_shape.shape.set_size(Vector2(_width, 9))
	
	if sprite:
		sprite.region_rect.size.x = _width
		sprite.region_rect.position.x = 0 if width == 0 else 16


func _update_type() -> void:
	if sprite:
		sprite.region_rect.position.y = (type + 1) * 16 - 16


func _standardise_speed() -> void:
	if animation_player:
		if standardise_speed:
			if "move" in animation_player.get_animation_list():
				
				# First need to calculate distance that is travelled
				var _from = animation_player.get_animation("move").track_get_key_value(0, 0)
				var _to = animation_player.get_animation("move").track_get_key_value(0, 1)
				var _distance = _from.distance_to(_to)
				
				# Calculate the animation duration required to achieve desired speed
				var _time = _distance / speed
				
				# Set animation length and move second key (animation should only have two keys, acting on platform.transform)
				animation_player.get_animation("move").set("length", _time)
				animation_player.get_animation("move").track_set_key_time(0, 1, _time)
				
				return
		
			push_error("Expected animation 'move' on platform (with two keys on platform positions)")
			return
	
	
