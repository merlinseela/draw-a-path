extends Path2D

const SPEED = 300

@onready var player_node: CharacterBody2D = get_parent().get_node("Player")
@onready var arrow_node: CharacterBody2D = get_node("PathFollow2D/Arrow")
@onready var main_node: Node2D = get_parent().get_parent()

@onready var idle_orbit_distance: int
@onready var idle_orbit_desired_position: Vector2

var tracker_state
enum states {
	IDLE,
	PATHING,
	BACK
}

var tracker_orbit_degrees: int
var tracker_points: int

# Called when the node enters the scene tree for the first time.
func _ready():
	tracker_state = states.IDLE


	idle_orbit_distance = 100
	#arrow_node.position = player_node.position + Vector2(idle_orbit_distance,0)
	tracker_orbit_degrees = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match tracker_state:
		states.IDLE:
		# Arrow orbiting
			#tracker_orbit_degrees += 2
			#arrow_node.position = player_node.position + Vector2(idle_orbit_distance, 0).rotated(deg_to_rad(tracker_orbit_degrees))
		#TODO: Orbeting not perfect ...
		#TODO: ERROR IN PATH2D cause problems.... we need to get rid of it ... but do not know how yet.--.-.--
		# Arrow Pathing control
			if curve.get_point_position(0) != player_node.position:
				curve.remove_point(0)
				curve.add_point(player_node.position, Vector2(0,0), Vector2(0,0), 0)
				
			if Input.is_action_just_pressed("mouse_click_left"):
				_add_point_path(get_viewport().get_mouse_position())
			
			if Input.is_action_just_pressed("mouse_click_right"):
				#arrow_node.position = Vector2(0,0)
				#arrow_node.position = player_node.position
				tracker_state = states.PATHING
				tracker_points = curve.point_count
				if tracker_points == 1:
					tracker_state = states.IDLE
				#TODO: SOMEONE we can kill it here -> now no detection is working anymore
				
		states.PATHING:
			if curve.get_point_position(tracker_points) != player_node.position:
				curve.remove_point(tracker_points)
				curve.add_point(player_node.position, Vector2(0,0), Vector2(0,0), tracker_points)
				
			$PathFollow2D.progress += SPEED * delta
			
			# if player hit right click -> abort path => clear points and add one point with current position and player point
			if Input.is_action_just_pressed("mouse_click_right"):
				curve.clear_points()
				tracker_state = states.BACK
				
		states.BACK:
			if curve.get_point_position(0) == Vector2(0,0):
				curve.add_point(arrow_node.global_position)
				
			if curve.get_point_position(1) == Vector2(0,0):
				curve.add_point(player_node.position)
			
			if curve.get_point_position(1) != player_node.position:
				curve.remove_point(1)
				curve.add_point(player_node.position, Vector2(0,0), Vector2(0,0), 1)

			$PathFollow2D.progress += SPEED * delta
			
func _add_point_path(cords_for_point: Vector2):
	curve.add_point(cords_for_point)


func _on_hitbox_area_entered(area):
	print(area)
	var area_parent = area.get_parent()
	if area.name == "CrustyArrowArea":
		if tracker_state != states.IDLE:
			curve.clear_points()
			$PathFollow2D.progress = 0
			$PathFollow2D.progress_ratio = 0
			tracker_state = states.IDLE
	
	if area_parent.health != 0:
		area_parent.health -= 1
		if area_parent.health == 0:
			area.free()
		main_node.enemy_count -= 1
