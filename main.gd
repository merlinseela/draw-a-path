extends Node2D

@onready var enemy: PackedScene = preload("res://scenes/enemy/enemy.tscn")
var test

var enemy_count: int = 1
var enemy_count_max: int

func _ready():
	# current enemy numbers
	enemy_count_max = 5


func _process(delta):
	while enemy_count <= enemy_count_max:
		enemy_count += 1
		var enemy_new: CharacterBody2D = enemy.instantiate()
		add_child(enemy_new)
		
		$Tilemap/TileMap.size_x_tilemap
		$Tilemap/TileMap.size_y_tilemap
		
		enemy_new.position = Vector2(100,100)
		
