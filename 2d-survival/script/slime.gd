extends CharacterBody2D

var speed = 50
var health = 100
var dead = false
var player_in_area = false
var player
var player_died = false
@onready var slime = $Slime_Collectable
@export var itm_res: invitem

func _ready():
	dead = false
	
func _process(delta: float) -> void:
	if dead and player_in_area:
		if Input.is_action_just_pressed("Interact"):
			player.collect(itm_res)
			await get_tree().create_timer(0.1).timeout
			queue_free()

func _physics_process(delta: float) -> void:
	if player_died:
		$player_detection/CollisionShape2D.disabled = true
	elif !dead:
		$player_detection/CollisionShape2D.disabled = false
		if player_in_area:
			position += (player.position - position)/speed
			$AnimatedSprite2D.play("Move")
		else:
			$AnimatedSprite2D.play("Idle")
	elif dead:
		$player_detection/CollisionShape2D.disabled = true

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true
		player = body


func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false


func _on_hitbox_area_entered(area: Area2D) -> void:
	var damage
	if area.has_method("arrow_damage"):
		damage = 50
		take_damage(damage)
		
func take_damage(damage):
	health -= damage
	if health <= 0 and !dead:
		death()
		
func death():
	dead = true
	$AnimatedSprite2D.play("Death")
	await get_tree().create_timer(1).timeout
	drop_slime()
	$AnimatedSprite2D.visible = false
	$Attack/CollisionShape2D.disabled = true
	$Hitbox/CollisionShape2D.disabled = true
	$player_detection/CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = true
	
func drop_slime():
	player_in_area = false
	slime.visible = true
	$Slime_Collectable/CollisionShape2D.disabled = false

func _on_slime_collectable_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_in_area = true


func _on_slime_collectable_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false


func _on_attack_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player.got_hit(20,global_position)
		if player.health <=0:
			player_died = true
