extends Node2D
class_name WeaponBehavior

@export var weapon:Weapon

var critical:bool=false
#不知道这个有啥用，暴击伤害下面函数已经有了，为嘛还要这个？后续再看
func execute_attack()->void:
	pass

func base_damage()->int:
	var damage:int=Global.player.stats.damage+weapon.data.stats.damage
	if Global.success(weapon.data.stats.crit_chance):
		damage=int(damage*weapon.data.stats.crit_multiple)
		critical=true
	return damage

func leech()->void:
	var leech_ratio:=(Global.player.stats.life_steal/100.0)+weapon.data.stats.leech
	if is_instance_valid(Global.player):
		var life:=int(base_damage()*leech_ratio)
		Global.player.health.heal(life)
		Global.heal_text.emit(Global.player,life)
