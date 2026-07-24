class_name PlayerHeart
extends Node

@export var bpm : int = 72
@export var bpm_max : int = 200 
var slide : int = 0
var slide_timer : float = 0
@export var test_container : Node
@export var view : SubViewport

signal bpm_max_reached
signal bpm_changed(new_bpm : int)
signal slide_changed(v : int)

func set_slide(v : int):
	slide = v
	slide_changed.emit(slide)

func change_bpm(offset : int):
	bpm = clampi(bpm+offset, 72, bpm_max)
	if bpm >= bpm_max:
		bpm_max_reached.emit()
	bpm_changed.emit(bpm)

func _ready() -> void:
	bpm_changed.emit(bpm)

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_LEFT): 
		change_bpm(-2)
		pass
	if Input.is_key_pressed(KEY_RIGHT):
		change_bpm(2)
		pass
	
	if slide != 0:
		slide_timer += delta
		if slide_timer >= 2.0:
			slide_timer = 0
			change_bpm(slide + randi_range(-1,1) )
	
	#if test_container.get_child_count() > 0:
		#var image = view.get_texture().get_image()
		#var image_texture := ImageTexture.create_from_image(image)
		#for child in test_container.get_children():
			#child.texture = image_texture
