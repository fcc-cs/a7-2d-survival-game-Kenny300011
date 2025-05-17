extends Node2D

@onready var animationplayer= $ForestCutscene/AnimationPlayer
@onready var camera = $ForestCutscene/Path2D/PathFollow2D/Camera2D

var is_openingcutscene = false
var has_player_entered_area = false
var player = null
var is_pathfollowing = false

func _physics_process(delta: float) -> void:
	if is_openingcutscene:
		var pathfollower = $ForestCutscene/Path2D/PathFollow2D
		if is_pathfollowing:
			pathfollower.progress_ratio += 0.001
			if pathfollower.progress_ratio >=1:
				cutsceneclose()

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
	player.camera = true
	$ForestCutscene.visible = false
	$ForestMain.visible = true
