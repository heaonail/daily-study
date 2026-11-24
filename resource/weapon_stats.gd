extends Resource
class_name WeaponStats

@export var damage:int=1
@export_range(0.0,1.0) var accurace:float=0.9
@export_range(0.5,3.0) var cooldown:float=2.0
@export_range(0.0,1.0) var crit_chance:float=0.1
@export var crit_multiple:float=2.0
@export var max_range:int=64
@export var knock_back:int=32
@export_range(0.0,1.0) var leech:float=0.1
@export var recoil:float=16
@export_range(0.1,3.0) var recoil_duration:float=1.0
@export_range(0.1,3.0) var attack_duration:float=1.0
@export_range(0.1,3.0) var back_duration:float=0.5
@export_range(0.1,3.0) var knock_back_duration:float=1.0
@export var projectile_scene:PackedScene
@export var projectile_speed:int=1024
