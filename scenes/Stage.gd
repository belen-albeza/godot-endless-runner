extends Node2D

export (int) var SCROLL_SPEED = 100
export (PackedScene) var ObstacleScene = null
export (int) var SPAWN_PROBABILITY = 85
export (int) var SPAWN_OFFSET_X = 100
export (float) var SCORE_DAMPING = 0.05

# Declare member variables here. Examples:
var level_x = 0
var is_game_over = false
var ground_y = 0
var screen_width = 0

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	ground_y = $Character.position.y + $Character.get_height()/2
	screen_width = get_viewport_rect().size.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_game_over:
		level_x += SCROLL_SPEED * delta
		$Character.position.x = level_x
		self._update_score(floor(level_x * SCORE_DAMPING))

func _on_Character_died():
	get_tree().reload_current_scene()

func _on_Character_death_started():
	is_game_over = true

func _on_ObstacleSpawnTimer_timeout():
	if rand_range(0, 100) < SPAWN_PROBABILITY:
		self._spawn_obstacle()

func _spawn_obstacle():
	var obstacle = ObstacleScene.instance()
	obstacle.position.y = ground_y
	obstacle.position.x = level_x + screen_width + rand_range(0, SPAWN_OFFSET_X)
	$Obstacles.add_child(obstacle)

func _update_score(value):
	score = value
	$UILayer/ScoreLabel.text = "Score: " + str(value)
