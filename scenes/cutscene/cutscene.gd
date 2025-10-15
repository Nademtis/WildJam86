extends Node
#cutscene unlock mask
@onready var player: Player = $"../ysort/player"

func _on_start_cutscene_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		print("start cutscene")
		player.velocity = Vector2.ZERO
		player.can_move = false
		player.animated_sprite_2d.play("stand_still")
	pass # Replace with function body.
