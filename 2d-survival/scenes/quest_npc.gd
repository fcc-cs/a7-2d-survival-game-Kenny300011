extends CharacterBody2D

var is_chatting = false
var player
var player_in_chat = false


func _ready():
	$AnimatedSprite2D.play("Idle")
	
func _process(delta: float) -> void:
	if player_in_chat:
		if Input.is_action_just_pressed("Interact"):
			$Quest.next_quest()
			is_chatting = true
			$AnimatedSprite2D.stop()
			


func _on_quest_quest_menu_closed() -> void:
	is_chatting = false
	$AnimatedSprite2D.play("Idle")

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_in_chat = true

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_chat = false

func _on_player_stick_collected() -> void:
	$Quest.stick_collected()


func _on_player_slime_collected() -> void:
	$Quest.slime_collected()
