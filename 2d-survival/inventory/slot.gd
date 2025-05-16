extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/Item_display
@onready var amount_txt: Label = $CenterContainer/Panel/Label
func update(slot: Inv_slot):
	if !slot.item:
		item_visual.visible = false
		amount_txt.visible = false
	else:
		item_visual.texture = slot.item.texture
		item_visual.visible = true
		if slot.amount > 1:
			amount_txt.visible = true
		amount_txt.text = str(slot.amount)
