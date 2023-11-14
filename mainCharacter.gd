extends CharacterBody2D


var speed := 500


#Dashing
var canDash := true
var dashingSpeed = 2000
var normalSpeed = 600
var sprintSpeed = 1000
var stamina = 100
var sprint := false
var weapon = "melee"

# We map a direction to a frame index of our AnimatedSprite node's sprite frames.
# See how we use it below to update the character's look direction in the game.

func _physics_process(_delta: float) -> void:
	# Once again, we call `Input.get_action_strength()` to support analog movement.
	var direction := Vector2(
		# This first line calculates the X direction, the vector's first component.
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		# And here, we calculate the Y direction. Note that the Y-axis points 
		# DOWN in games.
		# That is to say, a Y value of `1.0` points downward.
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	# When aiming the joystick diagonally, the direction vector can have a length 
	# greater than 1.0, making the character move faster than our maximum expected
	# speed. When that happens, we limit the vector's length to ensure the player 
	# can't go beyond the maximum speed.
	if direction.length() > 1.0:
		
		direction = direction.normalized()
	dash(direction)
	velocity = direction * speed
	
	move_and_slide()
	
	change_weapon()
	
	if sprint == true:
		stamina -= 1
	else:
		if stamina < 100:
			stamina += 1
func dash(direction: Vector2):
	if Input.is_action_just_pressed("dash") and canDash:
		speed = dashingSpeed
		canDash = false
		await get_tree().create_timer(0.1).timeout
		canDash = true
		sprint = true
		speed = sprintSpeed
	if (direction.length() == 0 and sprint) or stamina == 0:
		speed = normalSpeed
		sprint = false
		
func change_weapon():
	if Input.is_action_just_pressed("melee_weapon"):
		weapon = "melee"
	elif Input.is_action_just_pressed("ground_weapon"):
		weapon = "ground"
	elif Input.is_action_just_pressed("air_weapon"):
		weapon = "air"
# The code below updates the character's sprite to look in a specific direction.
