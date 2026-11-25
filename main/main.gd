extends Node2D
class_name Main

@export var player:PlayerTemplate

@onready var spawner: Spawner = $Spawner
@onready var upgrade_panel: UpgradePanel = $GameUI/UpgradePanel
@onready var shop_panel: ShopPanel = $GameUI/ShopPanel
@onready var coins_bag: CoinsBag = $GameUI/CoinsBag
var coin_list:Array[Coin]=[]

func _ready() -> void:
	Global.player=player
	Global.block_text.connect(creat_block_text)
	Global.hit_text.connect(creat_hit_text)
	Global.heal_text.connect(creat_heal_text)
	Global.on_upgrade_card_selected.connect(on_upgrade_select)
	Global.on_enemy_died.connect(_enemy_died)
	spawner.start_wave()

func creat_block_text(unit:Unit)->void:
	instantiate_float_text(unit,"block",Color.CORAL)
func creat_hit_text(unit:Unit,damage:int)->void:
	instantiate_float_text(unit,str(damage),Color.RED)
func creat_heal_text(unit:Unit,heal:int)->void:
	instantiate_float_text(unit,str(heal),Color.CHARTREUSE)

func instantiate_float_text(unit:Unit,s:String,color:Color)->void:
	var temp=Global.FLOAT_TEXT.instantiate() as FloatText
	add_child(temp)
	temp.global_position=unit.global_position+Vector2.UP*32
	temp.setup(s,color)

func start_new_wave()->void:
	Global.game_pause=false
	Global.player.update_player_new_wave()
	spawner.wave_index+=1
	spawner.start_wave()

func on_upgrade_select()->void:
	#upgrade_panel.hide()
	upgrade_panel.visible=false
	shop_panel.load_shop(spawner.wave_index)
	shop_panel.show()

func _on_spawner_on_wave_completed() -> void:
	if not is_instance_valid(Global.player):
		return
	clear_coins()
	await get_tree().create_timer(1.0).timeout
	upgrade_panel.apply_upgrade(spawner.wave_index)
	#print(spawner.wave_index)
	#Global.calculate_tier_odds(spawner.wave_index)
	#upgrade_panel.show()
	upgrade_panel.visible=true

func _on_shop_panel_on_next_wave() -> void:
	shop_panel.hide()
	start_new_wave()

func _enemy_died(enemy:EnemyTemplate)->void:
	spawn_coin(enemy)

func spawn_coin(enemy:EnemyTemplate)->void:
	var random_angle:=randf_range(0,TAU)
	var offset:=Vector2.RIGHT.rotated(random_angle)*32
	var spawn_pos:=enemy.global_position+offset
	var instance:=Global.COIN_SCENE.instantiate() as Coin
	coin_list.append(instance)
	instance.global_position=spawn_pos
	instance.value=enemy.stats.gold_drop
	call_deferred("add_child",instance)
	#add_child(instance)
	# spawn_coin(): Can't change this state while flushing queries. Use call_deferred() or set_deferred() to change monitoring state instead.

func clear_coins()->void:
	if coin_list.size()>0:
		var target_pos:=coins_bag.global_position
		for coin:Coin in coin_list:
			if is_instance_valid(coin):
				var temp:=coin as Coin
				temp.set_collect_target(target_pos)
	coin_list.clear()
