extends Node

func _on_btn_try_again_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/scn_level.tscn")

func _on_btn_give_up_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/scn_title_screen.tscn")
