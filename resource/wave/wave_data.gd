extends Resource
class_name WaveData

enum SpawnType{FIXED,RANDOM,}
@export var from:int
@export var to :int
@export var wave_time:float=20
@export var units:Array[WaveUnitData]=[]

@export var spawn_type:SpawnType=SpawnType.RANDOM
@export var spawn_time_fixed:float=2.0
@export var spawn_time_min:float=1.0
@export var spawn_time_max:float=3.0

func get_random_unit_scene()->PackedScene:
	if units.is_empty():
		return
	var enemies:Array[PackedScene]
	var weight:Array[float]
	
	for i in units:
		enemies.append(i.unit_scene)
		weight.append(i.weight)
	var rng:=RandomNumberGenerator.new()
	var random_unit=enemies[rng.rand_weighted(weight)]
	return random_unit

func is_valid_index(index:int)->bool:
	return index>=from and index<=to
