extends Area2D

@export var next_level_packed_scene : PackedScene

func _ready() -> void:
	if !next_level_packed_scene:
		print("no path given on ", self)
		queue_free()
		
	#Events.connect("screen_is_black", swap_level)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		#print("player is here. swap levels")
		swap_level()

func swap_level() -> void:
	Events.emit_signal("swap_level", next_level_packed_scene)
	
