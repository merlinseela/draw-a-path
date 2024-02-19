extends CharacterBody2D

@export var health = 1

const SPEED = 1250.0

@onready var enemy_sprites = [
	preload("res://scenes/enemy/stains_1.png"),
	preload("res://scenes/enemy/stains_2.png"),
	preload("res://scenes/enemy/stains_3.png")
]

@onready var enemy_collisions = [
	$CollisionEnemy1.disabled,
	$CollisionEnemy2.disabled,
	$CollisionEnemy3.disabled
]

@onready var enemy_area_collision = [
	$AreaCollisionEnemy/CollisionEnemy1.disabled,
	$AreaCollisionEnemy/CollisionEnemy2.disabled,
	$AreaCollisionEnemy/CollisionEnemy3.disabled
]

@onready var size_x: float
@onready var size_y: float

@onready var size_x_tilemap: int
@onready var size_y_tilemap: int

func _ready():
	var random: int = randi_range(0,2)
	$Sprite2D.texture = enemy_sprites[random]
	
	var tracker_loop: int = 0
	while tracker_loop < 3:
		if tracker_loop != random:
			enemy_collisions[tracker_loop] = true
			enemy_area_collision[tracker_loop] = true
		tracker_loop += 1
	
func _physics_process(delta):
	move_and_slide()
	velocity = SPEED * position.direction_to(get_parent().get_node("Player/Player").position) * delta
