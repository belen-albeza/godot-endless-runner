extends Node2D

export (int) var SCROLL_SPEED = 100

# Declare member variables here. Examples:
var level_x = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	level_x += SCROLL_SPEED * delta
	$Character.position.x = level_x

	# $ParallaxBackground.scroll_offset = Vector2(level_x, 0)
