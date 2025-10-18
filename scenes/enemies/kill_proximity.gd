extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		print("area entered stand enemy: ", area)
		if area.get_parent().can_kill_player():
			print_debug("stand enemy try to kill")
			area.get_parent().kill_player()
			set_deferred("monitoring", false)
