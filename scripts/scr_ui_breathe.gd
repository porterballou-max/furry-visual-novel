extends ProgressBar

func _on_breathe_air_changed(air: float) -> void:
	value = air * 100 
