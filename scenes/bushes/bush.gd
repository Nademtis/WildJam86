extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_movement_coll"):
		animation_player.play("pop_size")
