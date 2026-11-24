extends Area2D
class_name Hurtbox

signal get_hit(area:Hitbox)


func _ready() -> void:
	area_entered.connect(on_hitbox_entered)


func on_hitbox_entered(area:Area2D)->void:
	if area is Hitbox:
		get_hit.emit(area)
