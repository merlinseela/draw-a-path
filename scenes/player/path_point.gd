extends Node2D

@onready var mouse_on_point: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mouse_on_point == true:
		if Input.is_action_just_pressed("mouse_click_left"):
			get_parent().free()


func _on_area_2d_mouse_entered():
	mouse_on_point = true


func _on_area_2d_mouse_exited():
	mouse_on_point = false
