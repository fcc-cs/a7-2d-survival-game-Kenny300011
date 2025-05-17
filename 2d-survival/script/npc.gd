extends CharacterBody2D

const speed = 30
var current_state = Idle
var dir = Vector2.RIGHT
var start_pos
var is_roaming = true
var is_chatting = false
var player
var player_in_chat = false

enum{
	Idle,NewDir,Move
}

func _ready():
	randomize()
	start_pos = position
	
func _process(delta: float) -> void:
	if current_state == 0 or current_state == 1:
		$AnimatedSprite2D.play("Idle")
	elif current_state == 2 and !is_chatting:
		if dir.x == -1:
			$AnimatedSprite2D.play("Walk-W")
		if dir.x == 1:
			$AnimatedSprite2D.play("Walk-E")
		if dir.y == 1:
			$AnimatedSprite2D.play("Walk-S")
		if dir.y == -1:
			$AnimatedSprite2D.play("Walk-N")
			
	if is_roaming:
		match current_state:
			Idle:
				pass
			NewDir:
				dir = choose([Vector2.RIGHT,Vector2.LEFT,Vector2.UP,Vector2.DOWN])
			Move:
				move(delta)
	if player_in_chat:
		if Input.is_action_just_pressed("Interact"):
			$Dialogue.start()
			$Chat_Detection/CollisionShape2D.disabled = true
			is_roaming = false
			is_chatting = true
			$AnimatedSprite2D.play()
					
func choose(arr):
	arr.shuffle()
	return arr.front()
	
func move(delta):
	if !is_chatting:
		position += dir * speed * delta


func _on_chat_detection_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_in_chat = true


func _on_chat_detection_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_chat = false
		


func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([0.5,1,1.5])
	current_state = choose([Idle,NewDir,Move])


func _on_dialogue_d_finished() -> void:
	is_roaming = true
	is_chatting = false
	$Chat_Detection/CollisionShape2D.disabled = false
