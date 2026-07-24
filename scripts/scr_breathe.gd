extends Node

@export var heart : PlayerHeart
var inhaling : bool 
var air : float 
var calming_down : bool 
var calm_timer : float

signal air_changed(air : float)
signal calming_down_changed(state : bool)

func change_air(offset : float):
	if offset > 0 and air+offset >= 0.95:
		air = 1
	else:
		air = clampf(air+offset, 0, 1)
	air_changed.emit(air)
	
	if air <= 0 and calming_down:
		calming_down = false 

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("breathe"):
		heart.change_bpm( 7 )
		if calming_down:
			calming_down = false 
			calming_down_changed.emit(calming_down)
		inhaling = true
	elif event.is_action_released("breathe"):
		calming_down = true 
		calming_down_changed.emit(calming_down)
		inhaling = false 
	pass 

func _process(delta: float) -> void:
	
	if inhaling: 
		change_air(delta/2)
	else:
		change_air(-delta/4)
	
	if calming_down:
		calm_timer += delta
		if calm_timer >= 0.65: 
			calm_timer = 0.0
			heart.change_bpm( -3 )
	
	pass 
