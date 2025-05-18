extends CharacterBody2D

class_name pl

var speed = 100
var state
var health = 100
@onready var health_bar = $CanvasLayer/HealthBar
signal stick_collected
signal musicstop
signal slime_collected
var p_stop = false
var playerdead = false

@export var inv: Inventory
var bow_equiped = false
var bow_cooldown = true
var arrow = preload("res://scenes/arrow.tscn")
var mouse_loc_from_player = null
var bow_aim = false
var playerstop = false
@onready var camera = $Camera2D
@onready var canvas = $CanvasLayer


func _ready() -> void:
	pass
	
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
	if !p_stop and !playerstop and !playerdead:
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
			state = "stand_by"
			playerstop = true
			bow_aim = true
	else:
		bow_aim = false
		playerstop = false
	
	if Input.is_action_just_pressed("left_mouse") and bow_aim and bow_cooldown:
		$"../ArrowSFX".play()
		state = "launch"
		bow_cooldown = false
		var arrow_instance = arrow.instantiate()
		arrow_instance.rotation = $Marker2D.rotation
		arrow_instance.global_position = $Marker2D.global_position
		add_child(arrow_instance)
		play_animation(direction)
		bow_equiped = false
		await get_tree().create_timer(1).timeout
		bow_cooldown = true
		bow_equiped = true
		state = "stand_by"
	if !playerdead:
		play_animation(direction)
	
func play_animation(dir):
	if health <= 0:
		$AnimatedSprite2D.play("Death")
		playerstop = true
		playerdead = true
		gameover()
	if !bow_aim and !playerstop:
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
		if state == "stand_by":
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
		elif state == "launch":
			if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y < 0:
				$AnimatedSprite2D.play("N-ArrowLaunch")
			if mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x > 0:
				$AnimatedSprite2D.play("E-ArrowLaunch")
			if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y > 0:
				$AnimatedSprite2D.play("S-ArrowLaunch")
			if mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x < 0:
				$AnimatedSprite2D.play("W-ArrowLaunch")
			if mouse_loc_from_player.x >=25 and mouse_loc_from_player.y <= -25:
				$AnimatedSprite2D.play("NE-ArrowLaunch")
			if mouse_loc_from_player.x >=0.5 and mouse_loc_from_player.y >= 25:
				$AnimatedSprite2D.play("SE-ArrowLaunch")
			if mouse_loc_from_player.x <= -0.5 and mouse_loc_from_player.y >= 25:
				$AnimatedSprite2D.play("WS-ArrowLaunch")
			if mouse_loc_from_player.x <= -25 and mouse_loc_from_player.y <= -25:
				$AnimatedSprite2D.play("NW-ArrowLaunch")
func player():
	pass

func collect(item):
	inv.insert(item)
	print(item.resource_name)
	if item.resource_name == "stick":
		emit_signal("stick_collected")
	elif item.resource_name == "slime":
		emit_signal("slime_collected")

func take_damage(dmg):
	pass


func _on_forest_p_stop() -> void:
	p_stop = true


func _on_forest_p_start() -> void:
	p_stop = false
	
func got_hit(dmg,src_position):
	if health > 20:
		$"../DamageSFX".play()
	else:
		$"../PDeathSFX".play()
		emit_signal("musicstop")
	health -= dmg
	health_bar.value = health
	playerstop = true
	var pushback_dir = (global_position - src_position).normalized()
	var pushback_dist = 15
	var target_pos = global_position + pushback_dir * pushback_dist
	var tween = create_tween()
	tween.tween_property(self,"global_position",target_pos,0.2)
	await get_tree().create_timer(0.5).timeout
	playerstop = false

func gameover():
	await get_tree().create_timer(1).timeout
	$"../AnimationPlayer".play("FadeOut")
	$AnimationPlayer.play("FadeCanvas")
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://scenes/gameover.tscn")
	
