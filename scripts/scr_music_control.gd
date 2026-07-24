extends Node

@export var bpm_to_target_weight : Curve
var weight : float = 0  
var target_weight : float = 0
var weight_lerp_speed : float = 2

func _on_heart_bpm_changed(new_bpm: int) -> void:
	target_weight = bpm_to_target_weight.sample(new_bpm)
	print('NEW TARGET --> ', target_weight)
	for i in get_child_count():
		var local_weight : float = (abs(i-target_weight) / get_child_count()) * -80.0
		print(i, ' --> ', local_weight)
	
func _process(delta: float) -> void:
	
	weight = lerpf(weight, target_weight, weight_lerp_speed*delta)
	
	for i in get_child_count():
		var local_weight : float = (abs(i-weight) / get_child_count()) * -80.0
		get_child(i).volume_db = local_weight
	
	pass
