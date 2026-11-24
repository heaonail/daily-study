extends Panel
class_name UpgradePanel

const UPGRADE_CARD_SCENE = preload("uid://yn676bbjsj2g")

@export var upgrade_list:Array[ItemUpgrade]
@onready var item_container: HBoxContainer = %ItemContainer

#func _ready() -> void:
	#apply_upgrade()

func apply_upgrade(current_wave:int)->void:
	for child in item_container.get_children():
		child.queue_free()
	var selected_upgrade:=Global.select_item_offer(upgrade_list,current_wave)
	for upgrade_value:ItemUpgrade in selected_upgrade:
		var upgrade_card_instance:=UPGRADE_CARD_SCENE.instantiate() as UpgradeCard
		item_container.add_child(upgrade_card_instance)
		upgrade_card_instance.item_upgrade_data=upgrade_value
