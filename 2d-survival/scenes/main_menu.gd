extends Node2D

func _ready() -> void:
	starting()

func _on_play_pressed() -> void:
	$CanvasLayer/PLAY.disabled = true
	$CanvasLayer/QUIT.disabled = true
	$AnimationPlayer.play("Fadeout")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_quit_pressed() -> void:
	$CanvasLayer/PLAY.disabled = true
	$CanvasLayer/QUIT.disabled = true
	$AnimationPlayer.play("Fadeout")
	await get_tree().create_timer(1).timeout
	get_tree().quit()

func starting():
	$AnimationPlayer.play("TitleCard")
	await get_tree().create_timer(2).timeout
	$CanvasLayer/ColorRect.visible = true
	$CanvasLayer/PLAY.visible = true
	$CanvasLayer/QUIT.visible = true
	$TileMap.visible = true
	$AnimationPlayer.play("ColorRectFade")
