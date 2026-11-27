extends Panel
class_name ShopCard

@export var shop_item:Item :set=_set_shop_item
@onready var item_icon: TextureRect = %ItemIcon
@onready var item_name: Label = %ItemName
@onready var item_type: Label = %ItemType
@onready var item_description: RichTextLabel = %ItemDescription
@onready var price: Label = %Price

signal item_purchased(item:Item)

func _set_shop_item(value:Item)->void:
	shop_item=value
	item_icon.texture=value.item_icon
	item_name.text=value.item_name
	#item_type.text=str(value.item_type)
	item_type.text=Item.ItemType.keys()[value.item_type]
	item_description.text=value.item_description()
	price.text=str(value.item_cost)
	var style:=Global.get_tier_style(value.item_tier as Global.GlobalUpgradeTier)
	add_theme_stylebox_override("panel",style)

func _on_buy_button_pressed() -> void:
	if Global.equiped_weapon.size()>=6:return
	if Global.coins>=shop_item.item_cost:
		Global.coins-=shop_item.item_cost
		item_purchased.emit(shop_item)
		queue_free()
