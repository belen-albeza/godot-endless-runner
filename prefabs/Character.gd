extends Area2D

export (int) var JUMP_SPEED = 400
export (int) var GRAVITY = 800
export (float) var DEATH_ANIM_LENGTH = 0.25

signal died
signal death_started

var ground_y = 0
var speed_y = 0
var is_dying = false
var is_jumping = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ground_y = position.y
	$AnimatedSprite.play("walk")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var can_jump = not is_jumping and not is_dying

	if Input.is_action_just_pressed("chara_jump") and can_jump:
		is_jumping = true
		speed_y = -JUMP_SPEED
		$AudioJumpSfx.play()

	# update vertical position and speed
	speed_y += GRAVITY * delta
	speed_y = clamp(speed_y, -JUMP_SPEED, JUMP_SPEED)
	position.y += speed_y * delta
	position.y = min(position.y, ground_y) # don't go beyond ground level

	# update state and animations
	var is_on_ground = position.y >= ground_y
	if is_jumping and is_on_ground: # character just hit the ground
		is_jumping = false
		
	if is_dying:
		$AnimatedSprite.play("die")
	elif is_jumping and speed_y <= 0: # jumping:  going up
		$AnimatedSprite.play("jump")
	elif is_jumping and speed_y > 0: # jumping: falling down
		$AnimatedSprite.play("fall")
	else:
		$AnimatedSprite.play("walk")
	
func _on_Character_area_entered(area):
	if area.is_in_group("obstacles") and not is_dying:
		self._die()

func _die():
	is_dying = true

	$AudioHitSfx.play()

	$DeathTween.interpolate_property(
		$AnimatedSprite, "rotation", 0, PI/2,
		DEATH_ANIM_LENGTH, Tween.TRANS_SINE, Tween.EASE_IN)
	$DeathTween.interpolate_property(
		$AnimatedSprite, "position:y",
		$AnimatedSprite.position.y, $AnimatedSprite.position.y + 4,
		DEATH_ANIM_LENGTH, Tween.TRANS_SINE, Tween.EASE_IN)
	$DeathTween.start()

	var death_sfx_length = $AudioHitSfx.stream.get_length()
	var death_length = max(death_sfx_length, DEATH_ANIM_LENGTH)
	$DeathTimer.start(death_length)

	emit_signal("death_started")

func _on_DeathTimer_timeout():
	emit_signal("died")

func get_height():
	return $CollisionShape2D.shape.extents.y * 2
