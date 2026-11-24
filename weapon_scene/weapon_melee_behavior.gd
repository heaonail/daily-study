extends WeaponBehavior
class_name WeaponMeleeBehavior

@export var hitbox:Hitbox

func execute_attack()->void:
	weapon.is_attacking=true
	var tween:=create_tween()
	var recoil_position:=Vector2(weapon.attack_start_position.x-weapon.data.stats.recoil,weapon.attack_start_position.y)
	tween.tween_property(weapon.sprite,"position",recoil_position,weapon.data.stats.recoil_duration)
	hitbox.enable()
	hitbox.initial(base_damage(),critical,weapon.data.stats.knock_back,weapon.get_parent())
	var attack_position:=Vector2(weapon.attack_start_position.x+weapon.data.stats.max_range,weapon.attack_start_position.y)
	tween.tween_property(weapon.sprite,"position",attack_position,weapon.data.stats.attack_duration)
	leech()
	tween.tween_property(weapon.sprite,"position",weapon.attack_start_position,weapon.data.stats.back_duration)
	tween.finished.connect(func():
		hitbox.disable()
		weapon.is_attacking=false
		critical=false)
