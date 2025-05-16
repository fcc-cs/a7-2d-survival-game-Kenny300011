extends Control

@onready var Inv: Inventory = preload("res://inventory/playerinv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false

func _ready():
	Inv.update.connect(update_slots)
	update_slots()
	close()

func update_slots():
	for i in range(min(Inv.slots.size(),slots.size())):
		slots[i].update(Inv.slots[i])

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Tab"):
		if is_open:
			close()
		else:
			open()

func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false
