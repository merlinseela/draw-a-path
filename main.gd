extends Node2D

@onready var enemy: PackedScene = preload("res://scenes/enemy/enemy.tscn")
var test

var enemy_count: int = 1
var enemy_count_max: int

var enemy_possible_spawn_locations = []

func _ready():
	# current enemy numbers
	enemy_count_max = 0

	# calculate possible spawn locations
	var size_x: int = $Tilemap/TileMap.size_x_tilemap
	var size_y: int = $Tilemap/TileMap.size_y_tilemap

	# UpperBorder + Bottom Border
	var tracker_spawn_array: int = 1
	while tracker_spawn_array < size_x:
		enemy_possible_spawn_locations.append(Vector2(tracker_spawn_array, 1))
		enemy_possible_spawn_locations.append(Vector2(tracker_spawn_array, size_y - 1))
		tracker_spawn_array += 1
	
	# LeftBorder + RightBorder
	tracker_spawn_array = 2
	while tracker_spawn_array < size_y - 1:
		enemy_possible_spawn_locations.append(Vector2(1, tracker_spawn_array))
		enemy_possible_spawn_locations.append(Vector2((size_x - 1), tracker_spawn_array))
		tracker_spawn_array += 1

func _process(_delta):
	while enemy_count <= enemy_count_max:
		enemy_count += 1
		var enemy_new: CharacterBody2D = enemy.instantiate()
		add_child(enemy_new)
		enemy_new.position = $Tilemap/TileMap.map_to_local(enemy_possible_spawn_locations.pick_random())
	pass
