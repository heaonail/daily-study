extends Node2D
class_name ChargeBehavior

@export var entity:EnemyTemplate
@export var cooldown:float=3.0
@export var animation:AnimationPlayer

var is_charging:bool=false
var current_cooldown:float=0.0
var charge_attack_position:=Vector2.ZERO


func _ready() -> void:
	current_cooldown=cooldown

func _process(delta: float) -> void:
	if entity==null:
		return
	if is_charging:
		entity.global_position=entity.global_position.move_toward(charge_attack_position,(entity.stats.speed*5)*delta)
		if entity.global_position.distance_to(charge_attack_position)<100:
			end_charge()
	else:
		if current_cooldown>0:
			current_cooldown-=delta
		else:
			if is_instance_valid(Global.player):
				charge_attack_position=Global.player.global_position
				start_charge()

func end_charge()->void:
	is_charging=false
	current_cooldown=cooldown
	entity.can_move=true

func start_charge()->void:
	entity.can_move=false
	animation.play("charge")
	await animation.animation_finished
	is_charging=true
