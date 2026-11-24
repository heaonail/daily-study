extends Resource
class_name UnitStats

enum UnitType {PLAYER,ENEMY}

@export var name:String
@export var type:UnitType
@export var icon:Texture2D
@export var health:int=10
@export var max_health:int=100
@export var health_increase_per_wave:int=1
@export var damage:int=1
@export var damage_increase_per_wave:int=1
@export var speed:int=100
@export var luck:int=5
@export var block_chance:float=0.05
@export var gold_drop:int=1
@export var hp_regen:int=0
@export var life_steal:float=0.0
@export var harvesting:int=0
