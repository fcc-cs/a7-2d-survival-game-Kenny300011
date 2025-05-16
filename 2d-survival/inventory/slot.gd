extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/Item_display

func update(slot: Inv_slot):
	if !slot.item:
		item_visual.visible = false
	else:
		item_visual.texture = slot.item.texture
