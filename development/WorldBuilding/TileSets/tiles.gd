class_name Tiles extends Node2D

func _ready() -> void:
	LevelManager.change_level_bounds(get_tilemap_bounds())

func get_tilemap_bounds() -> Array[Vector2]:
	var bounds : Array[Vector2] = []
	
	var position_limits: Vector2
	var end_limits: Vector2
	var tile_size: int
	
	for c in get_children():
		if c is TileMapLayer:
			if c.get_used_rect().position.x < position_limits.x or position_limits == null:
				position_limits.x = c.get_used_rect().position.x
			if c.get_used_rect().position.y < position_limits.y or position_limits == null:
				position_limits.y = c.get_used_rect().position.y
			if c.get_used_rect().end.x > end_limits.x or end_limits == null:
				end_limits.x = c.get_used_rect().end.x
			if c.get_used_rect().end.y > end_limits.y or end_limits == null:
				end_limits.y = c.get_used_rect().end.y
			
			tile_size = c.rendering_quadrant_size

	bounds.append(
		Vector2(position_limits * tile_size)
	)
	
	bounds.append(
		Vector2(end_limits * tile_size)
	)

	return bounds
