extends Line2D

@onready var array_origin_node: Path2D = get_parent().get_node("Path2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if array_origin_node.arrow_path_points.size() != 1:
		#points = array_origin_node.arrow_path_points
	#else
