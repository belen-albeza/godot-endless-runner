extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (int) var JUMP_SPEED = 400
export (int) var GRAVITY = 800

var ground_y = 0
var speed_y = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	ground_y = position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var can_jump = position.y >= ground_y

	if Input.is_action_just_pressed("chara_jump") and can_jump:
		speed_y = -JUMP_SPEED

	# update vertical position and speed
	speed_y += GRAVITY * delta
	speed_y = clamp(speed_y, -JUMP_SPEED, JUMP_SPEED)
	position.y += speed_y * delta
	position.y = min(position.y, ground_y) # don't go beyond ground level
