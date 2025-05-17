extends Control

signal quest_menu_closed

var quest1_active = false
var quest1_complete = false
var stick = 0
var slime = 0
var quest2_active = false
var quest2_complete = false

signal dem_finish

func quest1_chat():
	$Quest1_UI.visible = true
	
func quest2_chat():
	$Quest2_UI.visible = true
	
func _process(delta: float) -> void:
	if quest1_active:
		if stick == 3:
			quest1_active = false
			quest1_complete = true
			play_finish_quest_anim()
	if quest2_active:
		if slime == 8:
			quest2_active = false
			quest2_complete = true
			print("Quest Complete")
		
func _on_yes_pressed() -> void:
	$Quest1_UI.visible = false
	$Quest2_UI.visible = false
	if !quest1_complete:
		quest1_active = true
		stick = 0
	elif !quest2_complete:
		quest2_active = true
		slime = 0
	emit_signal("quest_menu_closed")

func _on_no_pressed() -> void:
	$Quest1_UI.visible = false
	$Quest2_UI.visible = false
	emit_signal("quest_menu_closed")

func next_quest():
	if !quest1_complete and !quest1_active:
		quest1_chat()
	elif !quest2_complete and !quest2_active and quest1_complete:
		quest2_chat()
	elif quest1_active or quest2_active:
		$Quest_active.visible = true
		await get_tree().create_timer(3).timeout
		$Quest_active.visible = false
	elif quest2_complete:
		demo_finish()
	else:
		$No_Quest.visible = true
		await get_tree().create_timer(3).timeout
		$No_Quest.visible = false

func stick_collected():
	stick += 1

func slime_collected():
	slime += 1

func play_finish_quest_anim():
	$"Quest Finished".visible = true
	await get_tree().create_timer(3).timeout
	$"Quest Finished".visible = false

func demo_finish():
	$"Quest Finished2".visible = true
	await get_tree().create_timer(3).timeout
	$"Quest Finished2".visible = false
	get_tree().change_scene_to_file("res://scenes/demo_end.tscn")
