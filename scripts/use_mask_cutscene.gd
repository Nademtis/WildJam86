extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var blackborder_upper: ColorRect = $blackborderUpper
@onready var blackborder_lower: ColorRect = $blackborderLower

@onready var start_cutscene_area_2d: Area2D = $startCutsceneArea2D # to stop the triggering again
#@onready var enemy_area_2d: Area2D = $"../ysort/CUTSCENEenemyStandAndLook/light/Area2D"

var mask_max_time : float = 3.0
var current_mask_time : float = 0.0
var last_mask_step: int = -1  # for mask visuals
var mask_equipped : bool = false

var cutscene_is_showing : bool = true

@onready var player: Player = $"../ysort/player"

func _physics_process(delta: float) -> void:
	if mask_equipped:
		current_mask_time += delta
	else:
		current_mask_time -= delta * 2
	current_mask_time = clamp(current_mask_time, 0.0, mask_max_time) # so mask value not negative

func _process(_delta: float) -> void:
	if cutscene_is_showing:
		update_mask_visuals()
		pass

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
	mask_equipped = false
	player.animated_sprite_2d.play("stand_still")

func walk_right() -> void:
	player.step_playlist.play()
	player.animated_sprite_2d.play("walk_right")
	
func mask_walk_right() -> void:
	player.step_playlist.play()
	player.animated_sprite_2d.play("mask_walk_right")

func mask_idle() -> void:
	player.step_playlist.stop()
	mask_equipped = true
	player.animated_sprite_2d.play("mask_idle")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	start_cutscene_area_2d.monitoring = false # don't start again
	player.can_move = true
	#enemy_area_2d.monitoring = true # enemy can hit again
	
	#mask_equipped = false
	cutscene_is_showing = false
	Events.emit_signal("level_up_music", true)
	Events.emit_signal("level_up_music", true)
	Events.emit_signal("level_up_music", true)
	
	Events.emit_signal("health_changed", 0.0)

func update_mask_visuals() -> void:
	if mask_max_time <= 0:
		return
	
	# Calculate normalized value (0.0 to 1.0)
	var mask_percent := current_mask_time / mask_max_time
	
	# Calculate current 5% step
	var current_step := int(mask_percent * 20)
	
	# Only emit if step changed
	if current_step != last_mask_step:
		last_mask_step = current_step
		player.play_mask_sfx(mask_percent)
		Events.emit_signal("health_changed", mask_percent)
