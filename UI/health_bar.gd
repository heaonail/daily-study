extends Control
class_name HealthBar

@onready var label: Label = $Label
@onready var bar: ProgressBar = $Bar

var bashi:Color=Color(0,0.8,0)
var liushi:Color=Color(0.52,0.8,0)
var sishi:Color=Color(1,0.62,0)
var ershi:Color=Color(1,0.33,0)
var shi:Color=Color(1,0.17,0)
var ling:Color=Color(0,0,0)
var last_color_state:int=-1

func bar_color(current:int,max:int)->void:
	label.text=str(current)
	var ratio=float(current)/max
	bar.value=ratio
	var current_state:int
	match  ratio:
		_ when ratio>=0.8:current_state=5
		_ when ratio>=0.6:current_state=4
		_ when ratio>=0.4:current_state=3
		_ when ratio>=0.2:current_state=2
		_ when ratio>0.0:current_state=1
		_:current_state=0
	if last_color_state!=current_state:
		last_color_state=current_state
		var fill_style=bar.get_theme_stylebox("fill").duplicate() as StyleBoxFlat
		match current_state:
			5:fill_style.bg_color=bashi
			4:fill_style.bg_color=liushi
			3:fill_style.bg_color=sishi
			2:fill_style.bg_color=ershi
			1:fill_style.bg_color=shi
			0:fill_style.bg_color=ling
			
		bar.add_theme_stylebox_override("fill",fill_style)

func _on_health_health_change(current: int, max: int) -> void:
	bar_color(current,max)
