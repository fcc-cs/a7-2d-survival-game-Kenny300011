extends CharacterBody2D

var speed = 100
var state

@export var inv: Inventory

func _physics_process(delta):
	var direction = Input.get_vector("left","right","up","down")
	if direction.x == 0.0 and direction.y == 0.0:
		state = "idle"
	elif direction.x != 0 or direction.y != 0:
		state = "walk"
	if Input.is_action_pressed("Shift"):
		speed = 150
	else:
		speed = 100
	velocity = direction*speed
	move_and_slide()
	play_animation(direction)
	
func play_animation(dir):
	if state == "idle":
		$AnimatedSprite2D.play("Idle")
	if state == "walk":
		if dir.y == -1:
			$AnimatedSprite2D.play("N-Walk")
		if dir.x == +1:
			$AnimatedSprite2D.play("E-Walk")
		if dir.y == 1:
			$AnimatedSprite2D.play("S-Walk")
		if dir.x == -1:
			$AnimatedSprite2D.play("W-Walk")
		if dir.y < -0.5 and dir.x > 0.5:
			$AnimatedSprite2D.play("NE-Walk")
		if dir.y > 0.5 and dir.x > 0.5:
			$AnimatedSprite2D.play("SE-Walk")
		if dir.y > 0.5 and dir.x < -0.5:
			$AnimatedSprite2D.play("WS-Walk")
		if dir.y < -0.5 and dir.x < -0.5:
			$AnimatedSprite2D.play("NW-Walk")

func player():
	pass
