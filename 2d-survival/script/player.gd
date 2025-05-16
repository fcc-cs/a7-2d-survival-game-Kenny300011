extends CharacterBody2D

var speed = 100
var state

@export var inv: Inventory
var bow_equiped = false
var bow_cooldown = true
var arrow = preload("res://scenes/arrow.tscn")
var mouse_loc_from_player = null
var bow_aim = false
var playerstop = false

func _physics_process(delta):
	mouse_loc_from_player = get_global_mouse_position() - self.position
	var direction = Input.get_vector("left","right","up","down")
	if direction.x == 0.0 and direction.y == 0.0:
		state = "idle"
	elif direction.x != 0 or direction.y != 0:
		state = "walk"
	if Input.is_action_pressed("Shift"):
		speed = 150
	else:
		speed = 100
	if !playerstop:
		velocity = direction*speed
		move_and_slide()
	
	if Input.is_action_just_pressed("1"):
		if bow_equiped:
			bow_equiped = false
		else:
			bow_equiped = true
	
	var mouse_position = get_global_mouse_position()
	$Marker2D.look_at(mouse_position)
	
	if Input.is_action_pressed("right_mouse"):
		if bow_equiped:
			playerstop = true
			bow_aim = true
	else:
		bow_aim = false
		playerstop = false
	
	if Input.is_action_just_pressed("left_mouse") and bow_aim and bow_cooldown:
		bow_cooldown = false
		var arrow_instance = arrow.instantiate()
		arrow_instance.rotation = $Marker2D.rotation
		arrow_instance.global_position = $Marker2D.global_position
		add_child(arrow_instance)
		await get_tree().create_timer(1).timeout
		bow_cooldown = true
	play_animation(direction)
	
func play_animation(dir):
	if !bow_aim:
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
	if bow_aim:
		if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y < 0:
			$AnimatedSprite2D.play("N-Attack")
		if mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x > 0:
			$AnimatedSprite2D.play("E-Attack")
		if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y > 0:
			$AnimatedSprite2D.play("S-Attack")
		if mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x < 0:
			$AnimatedSprite2D.play("W-Attack")
		if mouse_loc_from_player.x >=25 and mouse_loc_from_player.y <= -25:
			$AnimatedSprite2D.play("NE-Attack")
		if mouse_loc_from_player.x >=0.5 and mouse_loc_from_player.y >= 25:
			$AnimatedSprite2D.play("SE-Attack")
		if mouse_loc_from_player.x <= -0.5 and mouse_loc_from_player.y >= 25:
			$AnimatedSprite2D.play("WS-Attack")
		if mouse_loc_from_player.x <= -25 and mouse_loc_from_player.y <= -25:
			$AnimatedSprite2D.play("NW-Attack")

func player():
	pass

func collect(item):
	inv.insert(item)
