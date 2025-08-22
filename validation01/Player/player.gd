class_name Player extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_box: HitBox = $HitBox

var hp: int
var max_hp := 1

const SPEED = 90.0
const JUMP_VELOCITY = -280.0

func _ready() -> void:
	hit_box.hit.connect(_take_hit)
	hp = max_hp

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	
	sprite.scale.x = direction if direction != 0 else sprite.scale.x
	
	if direction == 0:
		animation_player.play("idle")
	if direction != 0:
		animation_player.play("run")
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func _take_hit(_damage: int) -> void:
	hp -= _damage
	if hp <= 0:
		GameOver.show()
		hp = max_hp
