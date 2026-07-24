extends Node

func _on_btn_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/scn_level.tscn")

func _on_btn_quit_pressed() -> void:
	get_tree().quit()
