class_name DeathController 
extends Node

@export var fade_rect : ColorRect
const SCN_GAME_OVER = preload("uid://coloqjno7s0tm")

func _on_heart_bpm_max_reached() -> void:
	get_tree().paused = true 
	await get_tree().create_timer(2.0).timeout
	 
	fade_rect.color = Color(0,0,0,0)
	fade_rect.visible = true 
	var tween := fade_rect.create_tween()
	tween.tween_property(fade_rect, 'color', Color(0,0,0,1), 1.0)
	await tween.finished
	
	await get_tree().create_timer(0.5).timeout
	
	get_tree().paused = false 
	get_tree().change_scene_to_packed(SCN_GAME_OVER)
