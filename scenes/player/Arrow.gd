extends CharacterBody2D

func _ready():
	#global_position = get_parent().get_parent().get_parent().get_node("Player").position
	pass

func _physics_process(_delta):
	move_and_slide()

