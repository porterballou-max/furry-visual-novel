extends DialogScript

func execute(dialog_controller : DialogController) -> void:
	var character : AnimatedSprite2D = dialog_controller.get_tree().current_scene.find_child(&'Character', true)
	character.modulate = Color(1,1,1,0)
	character.visible = true 
	var tween := character.create_tween()
	tween.tween_property(character, 'modulate', Color(1,1,1,1), 1.0)
	await tween.finished
	tween.kill()
	pass 
