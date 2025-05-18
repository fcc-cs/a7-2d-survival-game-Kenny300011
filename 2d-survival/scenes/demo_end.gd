extends Node2D

func _ready():
	$Label.modulate.a = 0
	play_animation()
	
func play_animation():
	var twen = create_tween()
	twen.tween_property($Label,"modulate:a",1,2)
	await get_tree().create_timer(3).timeout
	var tween = create_tween()
	tween.tween_property($Label,"modulate:a",0,2)
	tween.tween_property($ColorRect,"modulate:a",0,2)
	await get_tree().create_timer(4).timeout
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
