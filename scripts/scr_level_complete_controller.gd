class_name LevelCompleteController
extends Node

@export var fade_rect : ColorRect

func complete_level():
	
	get_tree().paused = true 
	fade_rect.color = Color(0,0,0,0)
	fade_rect.visible = true 
	var tween := fade_rect.create_tween()
	tween.tween_property(fade_rect, 'color', Color(0,0,0,1), 2.0)
	await tween.finished
	await get_tree().create_timer(0.5).timeout
	
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/scn_level_completed.tscn")
	pass 
