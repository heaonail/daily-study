extends Node

signal block_text(unit:Unit)
signal hit_text(unit:Unit,damage:int)
signal heal_text(unit:Unit,heal:int)
signal on_upgrade_card_selected
signal on_enemy_died(enemy:EnemyTemplate)
const COIN_SCENE = preload("uid://doarpomhccaah")
const ITEM_CARD_SCENE = preload("uid://n5ehc4t0sbsh")

const GET_HIT_COLOR = preload("uid://btr1t4dd3jej6")
const FLOAT_TEXT = preload("uid://c73lt7upfbo50")
enum GlobalUpgradeTier{COMMON,EPIC,RARE,LEGENDARY}

const COMMON_STYLE = preload("uid://uq7mm7ahp4uj")
const EPIC_STYLE = preload("uid://ujkicu6wkcw4")
const LEGENDARY_STYLE = preload("uid://xlopgndcyrkk")
const RARE_STYLE = preload("uid://cmqw4l135c1vv")

const ODDS={
	"epic":{"start_wave":2,"base_multiple":0.06},
	"rare":{"start_wave":4,"base_multiple":0.02},
	"legendary":{"start_wave":8,"base_multiple":0.002},
}

var player:PlayerTemplate
var game_pause:bool=false
var coins:int=100
var equiped_weapon:Array[ItemWeapon]=[]
var selected_weapon:ItemWeapon

func success(chance:float)->bool:
	var temp=randf()
	if chance>=temp:
		return true
	else:
		return false

func calculate_tier_odds(current_wave:int)->Array:
	var common_odds:float=0.0
	var epic_odds:float=0.0
	var rare_odds:float=0.0
	var legendary_odds:float=0.0
	
	if current_wave>=ODDS.epic.start_wave:
		epic_odds=min(1.0,(current_wave-1)*ODDS.epic.base_multiple)
	if current_wave>=ODDS.rare.start_wave:
		rare_odds=min(1.0,(current_wave-3)*ODDS.rare.base_multiple)
	if current_wave>=ODDS.legendary.start_wave:
		legendary_odds=min(1.0,(current_wave-7)*ODDS.legendary.base_multiple)
	var luck_effect:float=1.0+float(Global.player.stats.luck)/100
	epic_odds*=luck_effect
	rare_odds*=luck_effect
	legendary_odds*=luck_effect
	var total_odds:float=epic_odds+rare_odds+legendary_odds
	if total_odds>1:
		var normalize_odds:float=1/(total_odds)
		epic_odds*=normalize_odds
		rare_odds*=normalize_odds
		legendary_odds*=normalize_odds
		total_odds=1.0
	common_odds=1.0-total_odds
	#print("wave:%d c_odds:%.2f e_odds:%.2f r_odds:%.2f,l_odds:%.2f"%[current_wave,common_odds,epic_odds,rare_odds,legendary_odds])
	return [max(0,common_odds),max(0,epic_odds),max(0,rare_odds),max(0,legendary_odds)]

func select_item_offer(item_pool:Array,current_wave:int)->Array:
	var tier_odds:Array=calculate_tier_odds(current_wave)
	#[0.7,0.2,0.08,0.02]
	var legendary_limit:float=tier_odds[3]
	var rare_limit:float=legendary_limit+tier_odds[2]
	var epic_limit:float=rare_limit+tier_odds[1]
	
	var offer_item:Array=[]
	
	while offer_item.size()<4:
		var roll:float=randf()
		var chosen_tier_index:int=0
		if roll<=legendary_limit:
			chosen_tier_index=3
		elif roll<=rare_limit:
			chosen_tier_index=2
		elif roll<=epic_limit:
			chosen_tier_index=1
		
		var potential_items:Array=[]
		var current_iter_index:int=chosen_tier_index
		while  potential_items.is_empty() and current_iter_index>=0:
			potential_items=item_pool.filter(func(item:Item): return item.item_tier==current_iter_index)
			if potential_items.is_empty():
				current_iter_index-=1
			else :
				break
		if not potential_items.is_empty():
			var selected_item:Item=potential_items.pick_random()
			if not offer_item.has(selected_item):
				offer_item.append(selected_item)
	return offer_item

func get_tier_style(tier:GlobalUpgradeTier)->StyleBoxFlat:
	match tier:
		GlobalUpgradeTier.COMMON:
			return COMMON_STYLE
		GlobalUpgradeTier.EPIC:
			return EPIC_STYLE
		GlobalUpgradeTier.RARE:
			return RARE_STYLE
		GlobalUpgradeTier.LEGENDARY:
			return LEGENDARY_STYLE
		_:
			return COMMON_STYLE

func get_harvest_coins()->void:
	coins+=player.stats.harvesting
