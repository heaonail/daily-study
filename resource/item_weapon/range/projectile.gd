extends Node2D
class_name Projectile

@onready var hitbox: Hitbox = $Sprite/Hitbox

var velocity:Vector2

func _process(delta: float) -> void:
	position+=velocity*delta

func initial_projectile(ve:Vector2,dam:int,crit:bool,knoback:int,user:Unit)->void:
	velocity=ve
	rotation=ve.angle()
	if hitbox:
		hitbox.initial(dam,crit,knoback,user)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_hitbox_hit(area: Hurtbox) -> void:
	queue_free()
