extends Node2D

@onready var fullscreen: bool = false

@onready var main_scene: PackedScene = preload("res://main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		$Main.free()
		$TextureRect.visible = true

func _on_fullscreen_pressed():
	if fullscreen == false:
		fullscreen = true
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		fullscreen = false
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_start_pressed():
	add_child(main_scene.instantiate())
	$TextureRect.visible = false
	$Main/Player/Player.health_depleted.connect(_on_health_depleted)

func _on_health_depleted():
	$TextureRect.visible = true
	$Main.free()
	
