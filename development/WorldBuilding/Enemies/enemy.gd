class_name Enemy extends Node2D

@onready var ray_cast: RayCast2D = $RayCast2D
@onready var hit_box: HitBox = $HitBox
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var direction : int = 1
var hp : int = 1

func _ready() -> void:
	hit_box.hit.connect(_take_hit)


func _process(delta: float) -> void:
	position.x += 40 * delta * direction
	if ray_cast.is_colliding():
		direction *= -1
		scale.x = direction


func _take_hit(_damage: int) -> void:
	hp -= _damage
	if hp<=0:
		direction = 0
		animation_player.play("die")
		
