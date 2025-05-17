extends Control

signal quest_menu_closed

var quest1_active = false
var quest1_complete = false
var stick = 0
func quest1_chat():
	$Quest1_UI.visible = true
	
func _process(delta: float) -> void:
	if quest1_active:
		if stick == 3:
			print("Quest Complete")
			quest1_active = false
			quest1_complete = true
		
func _on_yes_pressed() -> void:
	$Quest1_UI.visible = false
	quest1_active = true
	stick = 0
	emit_signal("quest_menu_closed")

func _on_no_pressed() -> void:
	$Quest1_UI.visible = false
	quest1_active = false
	stick = 0
	emit_signal("quest_menu_closed")

func next_quest():
	if !quest1_complete:
		quest1_chat()
	else:
		$No_Quest.visible = true
		await get_tree().create_timer(3).timeout
		$No_Quest.visible = false
