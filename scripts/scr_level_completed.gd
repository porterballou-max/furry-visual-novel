extends Node

func _on_btn_title_screen_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/scn_title_screen.tscn")

func _on_btn_quit_pressed() -> void:
	get_tree().quit()
