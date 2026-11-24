extends Item
class_name ItemUpgrade

@export var value:float=0.0
@export var description:String
@export var unit_stats_name:String

func applay_upgrade()->void:
	var temp_value:float=Global.player.stats.get(unit_stats_name)
	var new_value:=value+temp_value
	Global.player.stats.set(unit_stats_name,new_value)
	#temp_value+=value
	#Global.player.stats.set(unit_stats_name,temp_value)
