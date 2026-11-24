extends Resource
class_name Item

enum LocalUpgradeTier{COMMON,EPIC,RARE,LEGENDARY}
enum ItemType{WEAPON,UPGRADE,PASSIVE}

@export var item_name:String
@export var item_icon:Texture2D
@export var item_tier:LocalUpgradeTier
@export var item_type:ItemType
@export var item_cost:int

func item_description()->String:
	return ""
