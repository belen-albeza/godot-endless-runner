extends Node2D

export (int) var SCROLL_SPEED = 200
export (PackedScene) var STAGE_SCENE = null

# Declare member variables here. Examples:
var level_x = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	level_x += delta * SCROLL_SPEED
	$ParallaxBackground.offset.x = -level_x

func _input(event):
	if event.is_action_released("ui_accept"):
		get_tree().change_scene_to(STAGE_SCENE)