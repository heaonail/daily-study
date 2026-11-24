extends Panel
class_name UpgradeCard

@export var item_upgrade_data:ItemUpgrade:set=_set_data

@onready var item_icon: TextureRect = $MarginContainer/Control/ItemIcon
@onready var item_name: Label = $MarginContainer/Control/ItemName
@onready var item_description: Label = $MarginContainer/Control/ItemDescription


func _set_data(value:ItemUpgrade)->void:
	item_upgrade_data=value
	item_icon.texture=item_upgrade_data.item_icon
	item_name.text=item_upgrade_data.item_name
	item_description.text=item_upgrade_data.description
	var tier:=item_upgrade_data.item_tier as Global.GlobalUpgradeTier
	var style:=Global.get_tier_style(tier)
	add_theme_stylebox_override("panel",style)

func _on_custom_button_pressed() -> void:
	if item_upgrade_data and is_instance_valid(Global.player):
		item_upgrade_data.applay_upgrade()
		Global.on_upgrade_card_selected.emit()
