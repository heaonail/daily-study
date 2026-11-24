extends Area2D
class_name Coin

@export var collect_distance:float=16
@export var coin_speed:float=1000

var value:int=1
var target_pos_screen:Vector2=Vector2.INF
var target_pos:Vector2
var collected:bool=false

func _process(delta: float) -> void:
	if collected and target_pos_screen==Vector2.INF:
		if is_instance_valid(Global.player):
			target_pos=Global.player.global_position
	if target_pos_screen!=Vector2.INF:
		target_pos=get_canvas_transform().affine_inverse()*target_pos_screen
	if target_pos!=Vector2.ZERO:
		global_position=global_position.move_toward(target_pos,coin_speed*delta)
	if global_position.distance_to(target_pos)<collect_distance:
		add_coin()

func add_coin()->void:
	Global.coins+=value
	queue_free()

func set_collect_target(screen_pos:Vector2)->void:
	target_pos_screen=screen_pos

func _on_body_entered(body: Node2D) -> void:
	collected=true
