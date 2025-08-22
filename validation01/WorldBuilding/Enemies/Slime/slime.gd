class_name Slime extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var hit_box: HitBox = $HitBox
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var direction := 1
var hp := 1

func _ready() -> void:
	hit_box.hit.connect(_take_hit)


func _process(delta: float) -> void:
		
	position.x += 40 * delta * direction * int(hp>0)
	
	if ray_cast_right.is_colliding():
		direction = -1
	
	if ray_cast_left.is_colliding():
		direction = 1
	
	sprite.scale.x = direction


func _take_hit(_damage: int) -> void:
	hp -= _damage
	if hp <= 0:
		animation_player.play("die")
