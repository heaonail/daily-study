extends Node
class_name Health

signal take_hit
signal died
signal health_change(current:int,max:int)

var current_health:int=10
var max_health:int=100

func initial(stats:UnitStats)->void:
	current_health=stats.health
	max_health=stats.max_health
	health_change.emit(current_health,max_health)

func unit_died()->void:
	died.emit()
	owner.queue_free()

func take_damage(value:float)->void:
	if current_health<=0:
		return
	current_health=max(current_health-value,0)
	health_change.emit(current_health,max_health)
	take_hit.emit()
	if current_health<=0:
		unit_died()

func heal(value:float)->void:
	if current_health<=0:
		return
	current_health=min(current_health+value,max_health)
	health_change.emit(current_health,max_health)
