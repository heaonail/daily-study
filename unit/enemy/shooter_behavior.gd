extends Node2D
class_name ShooterBehavior

@export var entity:EnemyTemplate
@export var fire_pos:Marker2D
@export var cooldown:float=3.0
@export_range(2,5) var projectile_count:int=3
@export var projectile_dispersion:float=45
@export var projectile_scene:PackedScene
@export var projectile_speed:int=1024

var is_shooting:bool=false
var attack_position:Vector2=Vector2.ZERO

func _process(delta: float) -> void:
	if Global.game_pause:return
	if entity==null:
		return
	if cooldown>0:
		cooldown-=delta
	else:
		shoot()
		cooldown=3.0

func shoot()->void:
	if not is_instance_valid(Global.player):
		return
	entity.can_move=false
	var direction:=entity.global_position.direction_to(Global.player.global_position)
	var start_angle:=-projectile_dispersion/2.0
	var angle_step := 0.0 if projectile_count <= 1 else projectile_dispersion / float(projectile_count - 1)
	for i in projectile_count:
		var projectile:=projectile_scene.instantiate() as Projectile
		get_tree().current_scene.add_child(projectile)
		projectile.global_position=fire_pos.global_position
		var rotated_direction:=direction.rotated(deg_to_rad(start_angle+angle_step*i))
		var velocity:=rotated_direction*projectile_speed
		projectile.initial_projectile(velocity,entity.stats.damage,false,0,entity)
	await get_tree().create_timer(1).timeout
	entity.can_move=true
