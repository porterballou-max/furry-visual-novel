class_name DialogScript
extends Resource

func execute(dialog_controller : DialogController) -> void:
	print('/ BASE CLASS /')
	await dialog_controller.get_tree().process_frame
