extends CharacterBody2D

const SPEED = 300.0

@export var health: int = 5

@onready var main_node: Node2D = get_parent().get_parent()
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


func _on_crusty_enemy_area_area_entered(area):
	var area_parent = area.get_parent()
	if area.name == "AreaCollisionEnemy":
		health -= 1
		main_node.enemy_count -= 0
		area_parent.free()
	if health == 0:
		free() #TODO: Introduce Proper Gameover Screen _> this also needs a game start Screen
