extends Node2D
class_name Weapon

@onready var sprite: Sprite2D = $Sprite
@onready var range_area: Area2D = $RangeArea
@onready var collision: CollisionShape2D = $RangeArea/Collision
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var weapon_behavior: WeaponBehavior = $WeaponBehavior

var data:ItemWeapon
var is_attacking:bool=false
var attack_start_position:Vector2
var targets:Array[EnemyTemplate]=[]
var closest_target:EnemyTemplate
var weapon_spread:float

func _ready() -> void:
	attack_start_position=sprite.position
	range_area.body_entered.connect(range_area_body_entered)
	range_area.body_exited.connect(range_area_body_exited)

func _process(delta: float) -> void:
	if Global.game_pause:return
	if not is_attacking:
		#这个if有必要吗？后续验证
		if targets.size()==0:
			closest_target=null
		else:
			get_closest_target()
			rotate_to_target()
	if can_use_weapon():
		use_weapon()

func use_weapon()->void:
	weapon_behavior.execute_attack()
	cooldown_timer.wait_time=data.stats.cooldown
	cooldown_timer.start()

func range_area_body_entered(unit:EnemyTemplate)->void:
	targets.append(unit)
func range_area_body_exited(unit:EnemyTemplate)->void:
	targets.erase(unit)
	if targets.size()==0:
		closest_target=null

func rotate_to_target()->void:
	if closest_target==null:
		rotation=0
	else:
		var direction=global_position.direction_to(closest_target.global_position).angle()
		rotation=direction

func get_closest_target()->void:
	closest_target=compute_closest_target()
#personalize教程中额外创建这个函数，调用下面的函数，使closest_target=closest_enemy，
#个人感觉可以直接修改下面函数，使其不要返回值，直接closest_target=closest_enemy，不知道可不可行，
#做个记号，后续再说。
func compute_closest_target()->EnemyTemplate:
	if targets.size()==0:
		return null
	var closest_enemy:EnemyTemplate=targets[0]
	var closest_dis=global_position.distance_to(closest_enemy.global_position)
	for i in range(1,targets.size()): 
		var distance=global_position.distance_to(targets[i].global_position)
		if distance<=closest_dis:
			closest_enemy=targets[i]
			closest_dis=distance
	return closest_enemy

func set_weapon(value:ItemWeapon)->void:
	data=value
	collision.shape.radius=value.stats.max_range
	apply_tier_outline()

func can_use_weapon()->bool:
	if cooldown_timer.is_stopped() and closest_target!=null:
		return true
	else:
		return false

func apply_tier_outline()->void:
	if data.item_tier==Global.GlobalUpgradeTier.COMMON:
		sprite.material=null
		return
	var outline_color:=Global.TIER_COLOR[data.item_tier]
	sprite.material.set_shader_parameter("outline_color",outline_color)
