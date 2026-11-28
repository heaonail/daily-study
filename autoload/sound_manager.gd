extends Node
enum Sound{
	ENEMY_HIT,
	FIRE,
	UI
}
var sound_dictionary:Dictionary[Sound,Resource]={
	Sound.ENEMY_HIT:preload("uid://b70s1eac0naab"),
	Sound.FIRE:preload("uid://d03r25eukba74"),
	Sound.UI:preload("uid://dtrh7qipwvmb4")
}

@export var stream_player:Array[AudioStreamPlayer]

func play_sound(type:int)->void:
	var stream:=get_free_stream_player()
	if not stream:return
	var audio:=sound_dictionary[type]
	stream.stream=audio
	stream.pitch_scale=randf_range(0.8,1.3)
	stream.play()

func get_free_stream_player()->AudioStreamPlayer:
	for stream in stream_player:
		if not stream.playing:
			return stream
	return null
