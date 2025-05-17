extends Node2D

@onready var animationplayer= $ForestCutscene/AnimationPlayer
@onready var camera = $ForestCutscene/Path2D/PathFollow2D/Camera2D

var is_openingcutscene = false
var has_player_entered_area = false
var player = null
var is_pathfollowing = false
var smoke_happened = false
var smoke_happening = false

func _physics_process(delta: float) -> void:
	if is_openingcutscene:
		var pathfollower = $ForestCutscene/Path2D/PathFollow2D
		if is_pathfollowing:
			if !smoke_happening:
				pathfollower.progress_ratio += 0.001
			if pathfollower.progress_ratio >=1:
				cutsceneclose()
			if !smoke_happened and pathfollower.progress_ratio >= 0.822 and !smoke_happening:
				smoke_happening = true
				toggle_smoke()
				animationplayer.play("Zoom")
				await get_tree().create_timer(0.5).timeout
				$ForestMain.visible = true
				$ForestMain/TileMap/Slime6.visible = true
				$ForestMain/TileMap/Slime5.visible = true
				$ForestMain/TileMap/Slime4.visible = true
				toggle_smoke()
				await get_tree().create_timer(2).timeout
				smoke_happened = true
				smoke_happening = false
				
			if pathfollower.progress_ratio >= 0.9999:
				smoke_happening = true
				await get_tree().create_timer(1).timeout
				smoke_happening = false
				
			if pathfollower.progress_ratio >= 0.14:
				$ForestCutscene/SmokeParticle1.emitting = true
				await get_tree().create_timer(0.5).timeout
				$ForestCutscene/SmokeParticle1.emitting = false
				$ForestMain/TileMap/Slime.visible = true
				
			if pathfollower.progress_ratio >= 0.26:
				$ForestCutscene/SmokeParticle2.emitting = true
				await get_tree().create_timer(0.4).timeout
				$ForestCutscene/SmokeParticle2.emitting = false
				$ForestMain/TileMap/Slime3.visible = true

			if pathfollower.progress_ratio >= 0.33:
				$ForestCutscene/SmokeParticle3.emitting = true
				await get_tree().create_timer(0.4).timeout
				$ForestCutscene/SmokeParticle3.emitting = false
				$ForestMain/TileMap/Slime2.visible = true
				
			if pathfollower.progress_ratio >= 0.42:
				$ForestCutscene/SmokeParticle4.emitting = true
				await get_tree().create_timer(0.4).timeout
				$ForestCutscene/SmokeParticle4.emitting = false
				$ForestMain/TileMap/Slime8.visible = true
				
			if pathfollower.progress_ratio >= 0.55:
				$ForestCutscene/SmokeParticle5.emitting = true
				await get_tree().create_timer(0.4).timeout
				$ForestCutscene/SmokeParticle5.emitting = false
				$ForestMain/TileMap/Slime7.visible = true

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		if !has_player_entered_area:
			has_player_entered_area = true
			cutscene()
			
func cutscene():
	is_openingcutscene = true
	animationplayer.play("Fade")
	player.camera.enabled = false
	camera.enabled = true
	is_pathfollowing = true
	
func cutsceneclose():
	is_pathfollowing = false
	is_openingcutscene = false
	camera.enabled = false
	player.camera.enabled = true
	player.camera.limit_bottom = 719
	$ForestCutscene.visible = false
	$ForestMain.visible = true

func toggle_smoke():
	var smoke6 = $ForestCutscene/SmokeParticle6
	var smoke7 = $ForestCutscene/SmokeParticle7
	var smoke8 = $ForestCutscene/SmokeParticle8
	smoke8.emitting = !smoke8.emitting
	smoke7.emitting = !smoke7.emitting
	smoke6.emitting = !smoke6.emitting
