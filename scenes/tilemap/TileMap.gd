extends TileMap

@onready var size_x: float
@onready var size_y: float

@onready var size_x_tilemap: int
@onready var size_y_tilemap: int

@onready var loop_x_tracker: int
@onready var loop_y_tracker: int

# Called when the node enters the scene tree for the first time.
func _ready():
	size_x = get_viewport().size[0]
	size_y = get_viewport().size[1]

	size_x_tilemap = int(size_x / 16) - 1
	size_y_tilemap = int(size_y / 16)

	loop_x_tracker = 0
	loop_y_tracker = 0

	while (loop_y_tracker <= size_y_tilemap):
		while (loop_x_tracker <= size_x_tilemap):
			set_cell(0, Vector2i(loop_x_tracker,loop_y_tracker),0,Vector2i(randi_range(0,2),0), 0)
			loop_x_tracker += 1
		loop_y_tracker += 1
		loop_x_tracker = 0

func _process(_delta):
	pass
