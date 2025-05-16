extends StaticBody2D

@export var item: invitem
var player = null
var player_in_area = false

func _process(delta: float) -> void:
	if player_in_area:
		if Input.is_action_just_pressed("Interact"):
			playercollect()
			await get_tree().create_timer(0.1).timeout
			queue_free()
	

func _on_interact_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_in_area = true

func playercollect():
	player.collect(item)


func _on_interact_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false
