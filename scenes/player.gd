extends CharacterBody2D

const SPEED = 300.0

@onready var size_x: float
@onready var size_y: float

@onready var path_follow_node: PathFollow2D

func _ready():
	size_x = get_viewport().size[0]
	size_y = get_viewport().size[1]

	position = Vector2((size_x/2), (size_y/2))

	path_follow_node = get_node("ArrowComponent/Path2D/PathFollow2D")

func _physics_process(delta):
	move_and_slide()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var angle = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if angle:
		velocity = angle * SPEED
	else:
		velocity *= 0
		
	# arrow control
	path_follow_node.progress += SPEED * delta
	#print(path_follow_node)
	
	
	
