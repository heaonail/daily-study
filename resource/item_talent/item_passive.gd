extends Item
class_name ItemPassive

@export var add_value:float
@export var add_stats:String
@export var remove_value:float
@export var remove_stats:String

func item_description()->String:
	var description:String="[code]"
	
	if add_value!=0:
		description+="[color=green]+%s %s[/color]\n"% [add_value,add_stats]
	if remove_value!=0:
		description+="[color=red]-%s %s[/color]\n"% [remove_value,remove_stats]
	description+="[/code]"
	return description

func apply_passive()->void:
	if add_value!=0:
		Global.player.stats[add_stats]+=add_value
	if remove_value!=0:
		Global.player.stats[remove_stats]-=remove_value
