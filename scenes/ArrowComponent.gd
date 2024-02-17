extends Node2D

const SPEED = 300

@onready var player_node: CharacterBody2D = get_parent().get_node("Player")

var tracker_state
enum states {
	IDLE,
	PATHING,
	BACK
}

var tracker_progress: float
var tracker_points: int

# Called when the node enters the scene tree for the first time.
func _ready():
	tracker_state = states.IDLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match tracker_state:
		states.IDLE:
			if $Path2D.curve.get_point_position(0) != player_node.position:
				$Path2D.curve.remove_point(0)
				$Path2D.curve.add_point(player_node.position, Vector2(0,0), Vector2(0,0), 0)
				# TODO: In and Out Vectors are just 0,0 for now -> could stay like but not polished
				
			if Input.is_action_just_pressed("mouse_click_left"):
				_add_point_path(get_viewport().get_mouse_position())
			
			if Input.is_action_just_pressed("mouse_click_right"):
				tracker_state = states.PATHING
				tracker_points = $Path2D.curve.point_count + 1 # one to have the right value
				
				
		states.PATHING:
			#if $Path2D.curve.get_point_position(tracker_points) != player_node.position:
				#$Path2D.curve.remove_point(tracker_points)
				#$Path2D.curve.add_point(player_node.position, Vector2(0,0), Vector2(0,0), tracker_points + 1)
				
			#if $Path2D/PathFollow2D.progress_ratio < tracker_progress:
				#tracker_state = states.IDLE
				#$Path2D.curve.clear_points()
			#tracker_progress = $Path2D/PathFollow2D.progress_ratio
			$Path2D/PathFollow2D.progress += SPEED * delta
			
			if Input.is_action_just_pressed("mouse_click_right"):
				#for point in $Path2D.curve.points:
				print($Path2D.curve.get_baked_points())
			
			# check if path was finished if yes -> state to back and clear points from path
			# TODO: right now solution is somehwat resetting the position to the beginning (one frame over push in progress)
			
			
		states.BACK:
			pass
	
func _add_point_path(cords_for_point: Vector2):
	$Path2D.curve.add_point(cords_for_point)
