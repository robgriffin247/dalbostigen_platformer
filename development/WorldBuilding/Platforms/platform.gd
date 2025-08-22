@tool
class_name Platform extends Node2D


@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


enum TYPE {Grass, Sand, Lava, Ice}
enum WIDTH {Narrow, Wide}
enum SPEED {Static, Slow, Normal, Fast}

@export var type: TYPE = TYPE.Grass :
	set(_t):
		type = _t
		_update_type()


@export var width: WIDTH = WIDTH.Wide :
	set(_w):
		width = _w
		_update_width()

@export var start_position: Vector2 = Vector2.ZERO:
	set(_s):
		start_position = _s
		_update_position()
		
@export var end_position: Vector2 = Vector2.ZERO

@export var speed : SPEED = SPEED.Normal


func _ready() -> void:
	_update_position()
	_update_animation()
	_update_type()
	_update_width()

func _update_position():
	global_position = start_position
	
func _update_type() -> void:
	if sprite:
		sprite.region_rect.position.y = (type + 1) * 16 - 16


func _update_width() -> void:
	if sprite:
		sprite.region_rect.size.x = 16 * (width + 1)
		sprite.region_rect.position.x = 0 if width == 0 else 16

	if collision_shape:
		collision_shape.shape.size.y = 9
		collision_shape.shape.size.x = 16 * (width + 1)


func _update_animation():
	if animation_player:
		var _move_duration = 0.0 if speed == SPEED.Static else start_position.distance_to(end_position) / (speed * 20)
		
		animation_player.get_animation("move").set("length", _move_duration)
		
		if animation_player.get_animation("move").track_get_key_count(0) == 1:
			animation_player.get_animation("move").track_insert_key(0, 0.0, start_position, 1.0)
			
		if speed>0:
			animation_player.get_animation("move").track_insert_key(0, _move_duration, end_position, 1.0)
		
