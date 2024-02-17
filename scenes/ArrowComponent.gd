extends Node2D

const SPEED = 300

var tracker_state
enum states {
	IDLE,
	PATHING,
	BACK
}

var tracker_progress: float

# Called when the node enters the scene tree for the first time.
func _ready():
	_add_point_path(get_parent().get_node("Player").position)
	


	tracker_state = states.IDLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match tracker_state:
		states.IDLE:
			if Input.is_action_just_pressed("mouse_click_left"):
				_add_point_path(get_viewport().get_mouse_position())
			
			if Input.is_action_just_pressed("mouse_click_right"):
				tracker_state = states.PATHING
		states.PATHING:
			$Path2D/PathFollow2D.progress += SPEED * delta
			
			
			if $Path2D/PathFollow2D.progress_ratio < tracker_progress:
				tracker_state = states.IDLE
			
			tracker_progress = $Path2D/PathFollow2D.progress_ratio
			
		states.BACK:
			pass
	
	
	
	
	

	
func _add_point_path(cords_for_point: Vector2):
	$Path2D.curve.add_point(cords_for_point)
