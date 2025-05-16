extends Node2D

var state = "no apple"
var player_in_area = false
var apple = preload("res://scenes/apple_collectable.tscn")

@export var item: invitem
var player = null

func _ready():
	if state == "no apple":
		$Growth.start()
		
func _process(delta):
	if state == "no apple":
		$AnimatedSprite2D.play("Without Apple")
	if state == "apple":
		$AnimatedSprite2D.play("With Apple")
		if player_in_area:
			if Input.is_action_just_pressed("Interact"):
				state = "no apple"
				drop_apple()
				

func _on_pickarea_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true
		player = body


func _on_pickarea_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false




func _on_growth_timeout() -> void:
	if state == "no apple":
		state = "apple"

func drop_apple():
	var apple_instance = apple.instantiate()
	apple_instance.global_position = $Marker2D.global_position
	get_parent().add_child(apple_instance)
	player.collect(item)
	await get_tree().create_timer(3).timeout
	$Growth.start()
