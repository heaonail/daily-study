extends Node2D
class_name FloatText

@onready var label: Label = $Label
func setup(text:String,color:Color)->void:
	label.text=text
	modulate=color
	var tween=create_tween()
	tween.parallel().tween_property(self,"scale",Vector2.ONE*2,1.0)
	tween.parallel().tween_property(self,"modulate:a",0,1.0)
	tween.parallel().tween_property(self,"global_position",global_position+Vector2.UP*64,1.0)
	await  tween.finished
	queue_free()
