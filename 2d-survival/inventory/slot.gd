extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/Item_display

func update(item: invitem):
	if !item:
		item_visual.visible = false
	else:
		item_visual.texture = item.texture
