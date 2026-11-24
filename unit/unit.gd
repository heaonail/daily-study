extends CharacterBody2D
class_name Unit

@export var stats:UnitStats

@onready var animate: AnimatedSprite2D = $Animate
@onready var collision: CollisionShape2D = $Collision
@onready var health: Health = $Health

@onready var flash_timer: Timer = $FlashTimer

func _ready() -> void:
	health.initial(stats)

func flash_effect()->void:
	animate.material=Global.GET_HIT_COLOR
	flash_timer.start()

func _on_hurtbox_get_hit(area: Hitbox) -> void:
	if health.current_health<=0:
		return
	if Global.success(stats.block_chance):
		Global.block_text.emit(self)
		return
	health.take_damage(area.damage)
	Global.hit_text.emit(self,area.damage)
	flash_effect()


func _on_flash_timer_timeout() -> void:
	animate.material=null
