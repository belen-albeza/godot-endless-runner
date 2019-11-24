extends Node2D

export (int) var SCROLL_SPEED = 100

# Declare member variables here. Examples:
var level_x = 0
var is_game_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_game_over:
		level_x += SCROLL_SPEED * delta
		$Character.position.x = level_x

func _on_Character_died():
	get_tree().reload_current_scene()

func _on_Character_death_started():
	is_game_over = true
