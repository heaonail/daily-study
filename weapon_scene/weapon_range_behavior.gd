extends WeaponBehavior
class_name WeaponRangeBehavior

@onready var muzzle: Marker2D = $"../Sprite/Muzzle"

func execute_attack()->void:
	weapon.is_attacking=true
	creat_projectile()
	var tween:=create_tween()
	var recoil_position:=Vector2(weapon.attack_start_position.x-weapon.data.stats.recoil,weapon.attack_start_position.y)
	tween.tween_property(weapon.sprite,"position",recoil_position,weapon.data.stats.recoil_duration)
	tween.tween_property(weapon.sprite,"position",weapon.attack_start_position,weapon.data.stats.recoil_duration)
	leech()
	await tween.finished
	weapon.is_attacking=false
	critical=false

func creat_projectile()->void:
	var projectile:=weapon.data.stats.projectile_scene.instantiate() as Projectile
	get_tree().current_scene.add_child(projectile)
	projectile.global_position=muzzle.global_position
	var velocity:=Vector2.RIGHT.rotated(weapon.rotation)*weapon.data.stats.projectile_speed
	projectile.initial_projectile(velocity,base_damage(),critical,weapon.data.stats.knock_back,weapon.get_parent())
