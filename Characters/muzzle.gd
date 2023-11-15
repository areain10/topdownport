extends Marker2D

var bullet = preload("res://instances/bullet.tscn")
var canBullet := true
var bulletTime = 0.5

@onready var node = $muzzle3
@onready var playerPos = node.position
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if  Input.is_action_pressed("shoot"):
		if canBullet:
			var bullet_direction = playerPos.direction_to(get_global_mouse_position())
			fire(bullet_direction)
		bulletTime -= bulletTime/80
		bulletTime = clamp(bulletTime,0.05,5)
	else:
		bulletTime += 0.0005
		bulletTime = clamp(bulletTime,0.05,0.5)
		
	
func fire(bullet_direction: Vector2):
	canBullet = false
	var bulletInst = bullet.instantiate()
	get_tree().current_scene.add_child(bulletInst)
	bulletInst.rotation = bullet_direction.angle()
	bulletInst.global_position = self.global_position
	await get_tree().create_timer(bulletTime).timeout
	canBullet = true
	
