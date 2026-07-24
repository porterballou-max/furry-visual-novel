extends Control

var bpm : int
var heart_timer : float = 0.0  
@export var animated_sprite_2d : AnimatedSprite2D
@export var counter_label : RichTextLabel
@export var heart_texture_rect : TextureRect

func on_bpm_changed(new_bpm : int) -> void:
	bpm = new_bpm
	print('bpm became ', bpm)
	animated_sprite_2d.speed_scale = float(new_bpm)/60
	counter_label.text = str(new_bpm)

func _process(delta: float) -> void:
	heart_timer += delta
	if heart_timer >= 30.0/float(bpm):
		heart_timer = 0 
		heart_texture_rect.visible = !heart_texture_rect.visible
	pass 


func _on_heart_slide_changed(v: int) -> void:
	if v > 0:
		modulate = Color.RED
	else:
		modulate = Color.WHITE 
