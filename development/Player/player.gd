class_name Player extends CharacterBody2D

@onready var hit_box: HitBox = $HitBox

const SPEED = 100.0
const JUMP_VELOCITY = -320.0

var max_hp : int = 1
var hp : int

func _ready() -> void:
	hp = max_hp
	hit_box.hit.connect(_take_hit)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _take_hit(_damage: int) -> void:
	hp -= _damage
	if hp<=0:
		GameOver.show()
		hp = max_hp
