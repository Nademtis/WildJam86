extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var blackborder_upper: ColorRect = $blackborderUpper
@onready var blackborder_lower: ColorRect = $blackborderLower

@onready var player: Player = $"../ysort/player"

func _on_start_cutscene_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		print("start cutscene")
		player.velocity = Vector2.ZERO
		player.can_move = false
		player.step_playlist.stop()
		player.animated_sprite_2d.play("stand_still")
		
		await get_tree().create_timer(1).timeout
		animation_player.play("use_mask_cutscene")

func walk_down() -> void:
	player.step_playlist.play()
	player.animated_sprite_2d.play("walk_down")

func stop() -> void:
	player.step_playlist.stop()
	player.animated_sprite_2d.play("stand_still")

func walk_right() -> void:
	player.step_playlist.play()
	player.animated_sprite_2d.play("walk_right")
	
func mask_walk_right() -> void:
	player.step_playlist.play()
	player.animated_sprite_2d.play("mask_walk_right")
