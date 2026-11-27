extends Button
class_name ItemCard
signal item_card_selected(card:ItemCard)
@export var item:Item:set=_set_item
@onready var item_icon: TextureRect = $ItemIcon

func _set_item(value:Item)->void:
	item=value
	item_icon.texture=item.item_icon
	var style:=Global.get_tier_style(value.item_tier as Global.GlobalUpgradeTier)
	add_theme_stylebox_override("normal",style)

func _on_pressed() -> void:
	if item.item_type==Item.ItemType.WEAPON:
		#print(item.item_type)
		Global.selected_weapon=item as ItemWeapon
		item_card_selected.emit(self)
