extends Panel
class_name ShopPanel

const SHOP_CARD_SCENE = preload("uid://oidwksij4i1s")
@export var shop_item:Array[Item]=[]
@onready var item_container: HBoxContainer = %ItemContainer
@onready var passive_container: GridContainer = %PassiveContainer
@onready var weapon_container: GridContainer = %WeaponContainer

@onready var combine_button: Button = %CombineButton
var context_card:ItemCard

signal on_next_wave

func _ready() -> void:
	for child in passive_container.get_children():
		child.queue_free()
	for child in weapon_container.get_children():
		child.queue_free()

func load_shop(current_wave:int)->void:
	for child in item_container.get_children():
		child.queue_free()
	var selected_item:=Global.select_item_offer(shop_item,current_wave)
	for i in 4:
		var instance:=SHOP_CARD_SCENE.instantiate() as ShopCard
		instance.item_purchased.connect(_on_item_purchased)
		item_container.add_child(instance)
		instance.shop_item=selected_item[i]

func _on_new_wave_button_pressed() -> void:
	SoundManager.play_sound(SoundManager.Sound.UI)
	on_next_wave.emit()

func _on_item_purchased(item:Item)->void:
	var item_card:=creat_item_card()
	if item.item_type==Item.ItemType.WEAPON:
		weapon_container.add_child(item_card)
		item_card.item=item
		var weapon:=item as ItemWeapon
		Global.player.equip_weapon(weapon)
		Global.equiped_weapon.append(weapon)
	elif item.item_type==Item.ItemType.PASSIVE:
		passive_container.add_child(item_card)
		item_card.item=item
		var passive:=item as ItemPassive
		passive.apply_passive()

func creat_item_card()->ItemCard:
	var item_card:=Global.ITEM_CARD_SCENE.instantiate() as ItemCard
	item_card.item_card_selected.connect(_item_card_selected)
	return item_card

func _item_card_selected(card:ItemCard)->void:
	context_card=card
	var can_combine:bool=false
	if card.item.item_type==Item.ItemType.WEAPON:
		var count:int=0
		for i :ItemWeapon in Global.equiped_weapon:
			if i.item_name==card.item.item_name:
				count+=1
		if count>=2:
			can_combine=true
	combine_button.disabled=not can_combine
		

func _on_combine_button_pressed() -> void:
	SoundManager.play_sound(SoundManager.Sound.UI)
	if not context_card:
		return
	var temp_card:=context_card.item as ItemWeapon
	if temp_card.upgrade_to==null:
		return
	var weapon_remove:Array[Weapon]=Global.player.current_weapons.filter(func(w:Weapon):
		return w.data.item_name==temp_card.item_name).slice(0,2)
	var card_remove:=weapon_container.get_children().filter(func(c:ItemCard):
		return c.item.item_name==temp_card.item_name).slice(0,2)
	if weapon_remove.size()<2 or card_remove.size()<2:
		return
	for weapon:Weapon in weapon_remove:
		Global.player.current_weapons.erase(weapon)
		Global.equiped_weapon.erase(weapon.data)
		weapon.queue_free()
	for card:ItemCard in card_remove:
		card.queue_free()
	var up_weapon:ItemWeapon = load(temp_card.upgrade_to.resource_path)
	Global.player.equip_weapon(up_weapon)
	Global.equiped_weapon.append(up_weapon)
	var new_card:=creat_item_card()
	weapon_container.add_child(new_card)
	new_card.item=up_weapon
	context_card=null

func _on_sell_button_pressed() -> void:
	SoundManager.play_sound(SoundManager.Sound.UI)
	if context_card==null:
		return
	var clicked_weapon:=context_card.item as ItemWeapon
	var coins:=int(clicked_weapon.item_cost*0.75)
	var weapon_remove:Weapon=Global.player.current_weapons.filter(func(w:Weapon):
		return w.data.item_name==clicked_weapon.item_name).front()
	if weapon_remove:
		Global.player.current_weapons.erase(weapon_remove)
		Global.equiped_weapon.erase(weapon_remove.data)
		weapon_remove.queue_free()
	context_card.queue_free()
	context_card=null
	Global.coins+=coins

func creat_item_card_weapon(weapon:ItemWeapon)->void:
	var card=creat_item_card()
	weapon_container.add_child(card)
	card.item=weapon
