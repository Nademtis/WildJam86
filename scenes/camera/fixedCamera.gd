extends Area2D

@onready var phantom_camera_2d: PhantomCamera2D = $".."




func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		phantom_camera_2d.priority = 1


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		phantom_camera_2d.priority = 0
