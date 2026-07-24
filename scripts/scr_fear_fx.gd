extends Node

@export var snapshot_viewport : Viewport
const BLUR = preload("uid://cmxses2tl7kov")

var intensity : int = 0 
func set_intensity(x : int):
	if intensity == x: return 
	intensity = x 
	print('Setting intensity to ', intensity)
	for child in get_children():
		child.kill()
	match intensity:
		0:
			pass
		1:
			for i in 3: 
				var warble := FearWarble.new()
				warble.use_parent_material = true
				warble.speed = 0.5
				warble.intensity = 2.0 
				warble.modulate = Color(1,0.5,0.5,0.3)
				add_child(warble)
				print('Added child')
		2:
			for i in 4: 
				var warble := FearWarble.new()
				warble.use_parent_material = true
				warble.speed = 1.0
				warble.intensity = 3.0 
				warble.modulate = Color(1,0.5,0.5,0.3)
				add_child(warble)
				print('Added child')
		3:
			for i in 7: 
				var warble := FearWarble.new()
				warble.use_parent_material = true
				warble.speed = 1.5
				warble.intensity = 4.0 
				warble.modulate = Color(1,0.3,0.3,0.3)
				add_child(warble)
				print('Added child')
		4:
			for i in 15: 
				var warble := FearWarble.new()
				warble.use_parent_material = true
				warble.speed = 2.5
				warble.intensity = 5.0 
				warble.modulate = Color(1,0,0,0.3)
				add_child(warble)
				print('Added child')
	pass 

func _on_heart_bpm_changed(new_bpm: int) -> void:
	if new_bpm < 100:
		set_intensity(0)
	elif new_bpm < 120:
		set_intensity(1)
	elif new_bpm < 140:
		set_intensity(2)
	elif new_bpm < 160:
		set_intensity(3)
	elif new_bpm < 180:
		set_intensity(4)

func _process(delta: float) -> void:
	if get_child_count() > 0:
		var image = snapshot_viewport.get_texture().get_image()
		var image_texture := ImageTexture.create_from_image(image)
		for child : FearWarble in get_children():
			child.texture = image_texture
