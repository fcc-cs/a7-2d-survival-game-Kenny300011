extends Node2D

var input = false

func _ready():
	$AnimationPlayer.play("Go up")
	$".".visible = true
	$GAMEOVEROST.play()
	
func _process(delta: float) -> void:
	await get_tree().create_timer(2)
	input = true
	if input:
		if Input.is_action_just_pressed("esc"):
			$SelectSFX.play()
			$AnimationPlayer.play("FadeOut")
			input = false
			await get_tree().create_timer(4).timeout
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
