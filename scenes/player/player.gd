extends CharacterBody2D

const SPEED = 300.0

@export var health: int = 5

@onready var size_x: float
@onready var size_y: float


func _ready():
	size_x = get_viewport().size[0]
	size_y = get_viewport().size[1]
	position = Vector2((size_x/2), (size_y/2))


func _physics_process(_delta):
	move_and_slide()

	var angle = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if angle:
		velocity = angle * SPEED
	else:
		velocity *= 0
