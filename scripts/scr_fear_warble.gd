class_name FearWarble
extends TextureRect

var tween : Tween
var speed : float = 1
var intensity : float = 5.0

var base_position : Vector2 
var start_position : Vector2 
var goal_position : Vector2 
var progress : float 

const CURVE_EASE_IN_OUT : Curve = preload("uid://8xn14nddjcxb")

func _ready() -> void:
	
	var start_modulate := modulate
	var goal_modulate := modulate
	start_modulate.a = 0
	modulate = start_modulate
	create_tween().tween_property(self, 'modulate', goal_modulate, 3.0 )
	
	base_position = position  
	_refresh()

func kill():
	var start_modulate := modulate
	var goal_modulate := modulate
	goal_modulate.a = 0
	modulate = start_modulate
	var t := create_tween().tween_property(self, 'modulate', goal_modulate, 3.0 )
	await t.finished
	queue_free()

func _refresh():
	start_position = position 
	goal_position = base_position + Vector2.from_angle(randf()*2*PI) * intensity*randf_range(0.5,1.5)
	pass

func _process(delta: float) -> void:
	progress += delta * speed 
	position = start_position.slerp(goal_position, CURVE_EASE_IN_OUT.sample(progress))
	if progress >= 1:
		progress = 0 
		_refresh()
	
	pass 
