extends Area2D

var bullet_speed := 2000
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Vector2(1,0).rotated(rotation)
	position += direction * bullet_speed * delta
	
