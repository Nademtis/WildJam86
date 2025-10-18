extends Area2D


@export var level_up_music : bool = false
#@export var level_up_ambience : bool = false
@export var indented_level : int




func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		
		Events.emit_signal("level_up_music", level_up_music)
		#Events.emit_signal("level_up_ambience", level_up_ambience)
		set_deferred("monitoring", false)
