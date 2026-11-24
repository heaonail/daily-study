extends Node2D
class_name WeaponContainer

var weapon_position:Array[Vector2]


func _ready() -> void:
	for child:Marker2D in self.get_children():
		weapon_position.append(child.global_position)

func update_weapon_position(weapons:Array[Weapon])->void:
	var count:int=weapons.size()
	if count>weapon_position.size():
		return
	for i in count:
		weapons[i].global_position=weapon_position[i]
