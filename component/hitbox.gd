extends Area2D
class_name Hitbox

var damage:int=1
var critical:bool=false
var knock_back:int=1
var user:Unit

signal hit(area:Hurtbox)

func _ready() -> void:
	area_entered.connect(on_hurtbox_entered)

func disable()->void:
	set_deferred("monitorable",false)
	set_deferred("monitoring",false)

func enable()->void:
	set_deferred("monitorable",true)
	set_deferred("monitoring",true)

func initial(tdamage:int,tcritical:bool,tknockback:int,tuser:Unit)->void:
	damage=tdamage
	critical=tcritical
	knock_back=tknockback
	user=tuser

func on_hurtbox_entered(area:Area2D)->void:
	if area is Hurtbox:
		hit.emit(area)
	SoundManager.play_sound(SoundManager.Sound.ENEMY_HIT)
