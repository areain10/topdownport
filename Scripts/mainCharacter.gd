extends CharacterBody2D


var speed := 500


#Dashing
var canDash := true
var dashingSpeed = 2000
var normalSpeed = 600
var sprintSpeed = 1300
var stamina = 500
var sprint := false
var weapon = "melee"
#Fire
var bullet = preload("res://instances/bullet.tscn")
var canBullet := true
var bulletTime = 0.5

@onready var muzzle1 = $Marker2D/Sprite2D/muzzle
@onready var muzzle2 = $Marker2D/Sprite2D/muzzle2
@onready var characterPos = $Marker2D
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
	
	if  Input.is_action_pressed("shoot"):
		if canBullet:
			var bullet_direction = characterPos.global_position.direction_to(get_global_mouse_position())
			fire(bullet_direction, muzzle1.global_position)
			fire(bullet_direction, muzzle2.global_position)
		bulletTime -= bulletTime/80
		bulletTime = clamp(bulletTime,0.05,5)
	else:
		bulletTime += 0.0005
		bulletTime = clamp(bulletTime,0.05,0.5)
			
func dash(direction: Vector2):
	if Input.is_action_just_pressed("dash") and canDash:
		speed = dashingSpeed
		stamina -= 50
		stamina = clamp(stamina,0,10000)
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

func fire(bullet_direction: Vector2, muzzle_position: Vector2):
	canBullet = false
	var bulletInst = bullet.instantiate()
	get_tree().current_scene.add_child(bulletInst)
	bulletInst.rotation = bullet_direction.angle()
	bulletInst.global_position = muzzle_position
	await get_tree().create_timer(bulletTime).timeout
	canBullet = true
