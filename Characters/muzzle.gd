extends Marker2D

var bullet = preload("res://instances/bullet.tscn")
var canBullet := true
var bulletTime = 0.5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if  Input.is_action_pressed("shoot"):
		if canBullet:
			fire()
		bulletTime -= bulletTime/80
		bulletTime = clamp(bulletTime,0.05,5)
	else:
		bulletTime += 0.0005
		bulletTime = clamp(bulletTime,0.05,0.5)
		
	
func fire():
	canBullet = false
	var bulletInst = bullet.instantiate()
	add_child(bulletInst)
	await get_tree().create_timer(bulletTime).timeout
	canBullet = true
	
