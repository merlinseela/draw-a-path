extends Path2D

const SPEED = 300

@onready var player_node: CharacterBody2D = get_parent().get_node("Player")
@onready var arrow_node: CharacterBody2D = get_node("PathFollow2D/Arrow")
@onready var arrow_node_hitbox: Area2D = get_node("PathFollow2D/Arrow/Hitbox")
@onready var arrow_node_orbit: CharacterBody2D = get_parent().get_node("Arrow")
@onready var arrow_node_orbit_hitbox: Area2D = arrow_node_orbit.get_node("Hitbox")
@onready var main_node: Node2D = get_parent().get_parent()
@onready var path_draw: Line2D = get_parent().get_node("Line2D")

@onready var idle_orbit_distance: int
@onready var idle_orbit_desired_position: Vector2
@onready var arrow_path_points: PackedVector2Array = []

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
	arrow_path_points.append(player_node.position)

	idle_orbit_distance = 100
	arrow_node_orbit.position = player_node.position + Vector2(idle_orbit_distance,0)
	tracker_orbit_degrees = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("move_up"):
		pass
		
	match tracker_state:		
		states.IDLE:
		# drawing of line
			path_draw.points = arrow_path_points
			
		# visibility change of orbitting arrow
			arrow_node_orbit.visible = true
			arrow_node_orbit_hitbox.set_collision_layer_value(5, true)
			arrow_node_orbit_hitbox.set_collision_mask_value(3, true)
			arrow_node_orbit_hitbox.set_collision_mask_value(6, true)
			
		# visibility change of drawn arrow
			arrow_node.visible = false
			arrow_node_hitbox.set_collision_layer_value(5, false)
			arrow_node_hitbox.set_collision_mask_value(3, false)
			arrow_node_hitbox.set_collision_mask_value(6, false)
		
		# Arrow orbiting
			tracker_orbit_degrees += 2
			arrow_node_orbit.position = player_node.position + Vector2(idle_orbit_distance, 0).rotated(deg_to_rad(tracker_orbit_degrees))
			arrow_node_orbit.rotation = deg_to_rad(tracker_orbit_degrees + 270)
			
		# Arrow Pathing control
			if arrow_path_points[0] != player_node.position:
				arrow_path_points[0] = player_node.position
				
			if Input.is_action_just_pressed("mouse_click_left"):
				_add_point_path(get_viewport().get_mouse_position())
				
			if Input.is_action_just_pressed("mouse_click_right"):
				# visibility change of orbitting arrow
				arrow_node_orbit.visible = false
				arrow_node_orbit_hitbox.set_collision_layer_value(5, false)
				arrow_node_orbit_hitbox.set_collision_mask_value(3, false)
				arrow_node_orbit_hitbox.set_collision_mask_value(6, false)

				# visibility change of drawn arrow
				arrow_node.visible = true
				arrow_node_hitbox.set_collision_layer_value(5, true)
				arrow_node_hitbox.set_collision_mask_value(3, true)
				arrow_node_hitbox.set_collision_mask_value(6, true)
				
				# prep pathing state
				var tracker_path_add_loop: int = 0
				while tracker_path_add_loop < arrow_path_points.size():
					curve.add_point(arrow_path_points[tracker_path_add_loop])
					tracker_path_add_loop += 1
				
				tracker_points = curve.point_count
				tracker_state = states.PATHING
				if tracker_points <= 1:
					curve.clear_points()
					tracker_state = states.IDLE
				
		states.PATHING:
			
			if curve.get_point_position(tracker_points) != player_node.position:
				curve.remove_point(tracker_points)
				curve.add_point(player_node.position, Vector2(0,0), Vector2(0,0), tracker_points)
				
				if arrow_path_points.size() == tracker_points:
					arrow_path_points.append(player_node.position)
					path_draw.points = arrow_path_points
				else:
					arrow_path_points[tracker_points] = player_node.position
					path_draw.points = arrow_path_points
				
			$PathFollow2D.progress += SPEED * delta
			
			# if player hit right click -> abort path => clear points and add one point with current position and player point
			if Input.is_action_just_pressed("mouse_click_right"):
				curve.clear_points()
				tracker_state = states.BACK
				
		states.BACK:
			path_draw.points = []
			if curve.get_point_position(0) == Vector2(0,0):
				curve.add_point(arrow_node.global_position)
				
			if curve.get_point_position(1) == Vector2(0,0):
				curve.add_point(player_node.position)
			
			if curve.get_point_position(1) != player_node.position:
				curve.remove_point(1)
				curve.add_point(player_node.position, Vector2(0,0), Vector2(0,0), 1)

			$PathFollow2D.progress += SPEED * delta
			
func _add_point_path(cords_for_point: Vector2):
	#curve.add_point(cords_for_point)
	arrow_path_points.append(cords_for_point)

func _on_hitbox_area_entered(area):
	var area_parent = area.get_parent()
	if area.name == "CrustyArrowArea":
		if tracker_state != states.IDLE and curve.get_point_position(0) != player_node.position:
			curve.clear_points()
			$PathFollow2D.progress = 0
			$PathFollow2D.progress_ratio = 0
			tracker_state = states.IDLE
			player_node.position -= Vector2(0.001, 0.001)
			arrow_path_points = []
			arrow_path_points.append(player_node.position)
		player_node.position += Vector2(0.001, 0.001)
	
	if area.name == "AreaCollisionEnemy":
		area_parent.health -= 1
		if area_parent.health == 0:
			area_parent.free()
		main_node.enemy_count -= 1
