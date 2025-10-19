extends Node

@onready var player: Player = $"../ysort/player"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var craftingSFX: AudioStreamPlayer2D

func _ready() -> void:
	if has_node("CraftingSFX"):
		craftingSFX = $CraftingSFX

func _on_start_cutscene_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		#print("start cutscene")
		player.velocity = Vector2.ZERO
		player.can_move = false
		#player.step_playlist.stop()
		player.animated_sprite_2d.play("walk_right")
		
		await get_tree().create_timer(1).timeout
		animation_player.play("cutscene")
		
func walk_down() -> void:
	player.step_playlist.play()
	player.animated_sprite_2d.play("walk_down")

func stop() -> void:
	player.step_playlist.stop()
	player.animated_sprite_2d.play("stand_still")

func walk_right() -> void:
	player.step_playlist.play()
	player.animated_sprite_2d.play("walk_right")
	
func look_up() -> void:
	player.animated_sprite_2d.play("look_up")

func walk_up() -> void:
	player.step_playlist.play()
	player.animated_sprite_2d.play("walk_up")
	
func stand_still_look_up() -> void:
	player.step_playlist.stop()
	player.animated_sprite_2d.play("stand_still_look_up")
