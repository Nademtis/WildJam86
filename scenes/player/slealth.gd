extends Node2D

var is_hidden = false
var in_bush_list : Array = []

func check_if_hidden() -> void:
	if in_bush_list.is_empty():
		is_hidden = false
	else:
		is_hidden = true
	Events.emit_signal("is_hidden", is_hidden)

func _on_stealth_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bush"):
		in_bush_list.append(area)
	check_if_hidden()


func _on_stealth_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("bush"):
		in_bush_list.erase(area)
	check_if_hidden()
	
