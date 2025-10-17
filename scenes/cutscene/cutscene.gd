extends Node
#cutscene unlock mask
@onready var player: Player = $"../ysort/player"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var craftingSFX: AudioStreamPlayer2D = $CraftingSFX

func _on_start_cutscene_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		print("start cutscene")
		player.velocity = Vector2.ZERO
		player.can_move = false
		player.step_playlist.stop()
		player.animated_sprite_2d.play("stand_still")
		
		await get_tree().create_timer(1).timeout
		animation_player.play("create_mask_cutscene")
		
func walk_down() -> void:
	player.step_playlist.play()
	player.animated_sprite_2d.play("walk_down")

func stop() -> void:
	player.step_playlist.stop()
	player.animated_sprite_2d.play("stand_still")

func interact() -> void:
	player.step_playlist.stop()
	craftingSFX.play()
	player.animated_sprite_2d.play("interact")
	
func walk_right() -> void:
	player.step_playlist.play()
	player.animated_sprite_2d.play("walk_right")
	
