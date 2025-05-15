extends CharacterBody2D

var speed = 100
var state

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left","right",'up',"down")
	if direction.x == 0 and direction.y == 0:
		state = "idle"
	elif direction.x != 0 or direction.y != 0:
		state = "walk"
	velocity = direction*speed
	move_and_slide()
