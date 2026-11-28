extends Node2D
class_name Spawner

signal on_wave_completed

@export var wave_data:Array[WaveData]
@export var spawn_area:Vector2=Vector2(1100,600)
@export var enemy_collection:Array[UnitStats]

@onready var spawner_timer: Timer = $SpawnerTimer
@onready var wave_timer: Timer = $WaveTimer

@onready var wave_index_label: Label = $"../GameUI/WaveIndexLabel"
@onready var wave_timer_label: Label = $"../GameUI/WaveTimerLabel"

var wave_index:int=1
var current_wave_data:WaveData
var spawned_enemy:Array[EnemyTemplate]=[]

#func _ready() -> void:
	#start_wave()

func _process(delta: float) -> void:
	if Global.game_pause:return
	wave_index_label.text=get_wave_index_text()
	wave_timer_label.text=get_wave_time_text()

func find_wave_data()->WaveData:
	for wave in wave_data:
		if wave and wave.is_valid_index(wave_index):
			return wave
	return null

func start_wave()->void:
	current_wave_data=find_wave_data()
	if not current_wave_data:
		spawner_timer.is_stopped()
		wave_timer.is_stopped()
		return
	wave_timer.wait_time=current_wave_data.wave_time
	wave_timer.start()
	
	set_spawn_timer()

func set_spawn_timer()->void:
	match current_wave_data.spawn_type:
		WaveData.SpawnType.FIXED:
			spawner_timer.wait_time=current_wave_data.spawn_time_fixed
		WaveData.SpawnType.RANDOM:
			spawner_timer.wait_time=randf_range(current_wave_data.spawn_time_min,current_wave_data.spawn_time_max)
		
	if spawner_timer.is_stopped():
		spawner_timer.start()

func spawn_enemy()->void:
	var enemy_scene:=current_wave_data.get_random_unit_scene() as PackedScene
	if enemy_scene:
		var pos:=get_random_location()
		#var spawn_effect:EnemySpawnEffect____this is wrong
		var spawn_effect:=Global.ENEMY_SPAWN_EFFECT_SCENE.instantiate() as EnemySpawnEffect
		get_parent().add_child(spawn_effect)
		spawn_effect.global_position=pos
		spawn_effect.anim_player.play("spawn")
		#await  spawn_effect.anim_player.stop()_____wrong
		await  spawn_effect.anim_player.animation_finished
		spawn_effect.queue_free()
		
		var enemy_instance:=enemy_scene.instantiate() as EnemyTemplate
		enemy_instance.global_position=pos
		
		get_tree().current_scene.add_child(enemy_instance)
		spawned_enemy.append(enemy_instance)
	
	set_spawn_timer()

func _on_spawner_timer_timeout() -> void:
	if not current_wave_data or wave_timer.is_stopped():
		spawner_timer.stop()
		return
	spawn_enemy()

func get_wave_index_text()->String:
	return "Wave %s" % wave_index

func get_wave_time_text()->String:
	return str(int(wave_timer.time_left))

func get_random_location()->Vector2:
	var vector:=Vector2.ZERO
	vector.x=randf_range(0,spawn_area.x)
	vector.y=randf_range(0,spawn_area.y)
	return vector

func _on_wave_timer_timeout() -> void:
	Global.get_harvest_coins()
	spawner_timer.stop()
	on_wave_completed.emit()
	#print("wave-timer timeout")
	clear_enemy()
	update_enemy_new_wave()

func update_enemy_new_wave()->void:
	for stats:UnitStats in enemy_collection:
		stats.health+=stats.health_increase_per_wave
		stats.damage+=stats.damage_increase_per_wave

func clear_enemy()->void:
	Global.game_pause=true
	if spawned_enemy.size()>0:
		for enemy in spawned_enemy:
			if is_instance_valid(enemy):
				enemy.destory_enemy()
	spawned_enemy.clear()
