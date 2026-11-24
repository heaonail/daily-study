extends Unit
class_name EnemyTemplate

@onready var area_push: Area2D = $AreaPush
@onready var knock_back_timer: Timer = $KnockBackTimer
var back_direction:Vector2
var back_power:float

var can_move:bool=true

var push:int=16
var move_direction:Vector2=Vector2.ZERO

func _process(delta: float) -> void:
	if Global.game_pause:return
	if can_move==false:return
	velocity=(get_move_direction()+back_direction*back_power)*stats.speed
	animation()
	move_and_slide()

func get_move_direction()->Vector2:
	if is_instance_valid(Global.player) and self.global_position.distance_to(Global.player.global_position)>36:
		move_direction=global_position.direction_to(Global.player.global_position)
	else:
		move_direction=Vector2.ZERO
	for area:Area2D in area_push.get_overlapping_areas():
		var temp=global_position-area.global_position
		move_direction+=temp.normalized()*push/max(temp.length(),4)
	
	return move_direction

func animation()->void:
	if is_instance_valid(Global.player):
		var temp=global_position.direction_to(Global.player.global_position)
		if temp.x>0:
			animate.flip_h=false
		if temp.x<0:
			animate.flip_h=true
	if move_direction.length()==0:
		animate.play("idle")
	else :
		animate.play("run")

func reset_knockback()->void:
	back_direction=Vector2.ZERO
	back_power=0.0

func set_knockback(dir:Vector2,power:float)->void:
	back_direction=dir
	back_power=power

func _on_hurtbox_get_hit(area: Hitbox) -> void:
	super._on_hurtbox_get_hit(area)
	var temp_dir:Vector2=area.owner.global_position.direction_to(global_position)
	set_knockback(temp_dir,area.knock_back)
	knock_back_timer.start()

func _on_knock_back_timer_timeout() -> void:
	reset_knockback()

func destory_enemy()->void:
	animate.play("died")
	await animate.animation_finished
	queue_free()

func _on_health_died() -> void:
	Global.on_enemy_died.emit(self)
