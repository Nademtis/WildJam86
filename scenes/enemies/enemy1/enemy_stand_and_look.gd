@tool
extends Node2D

@onready var animated_mask: AnimatedSprite2D = $Animated_mask
@onready var animated_body: AnimatedSprite2D = $Animated_body

@onready var light: Node2D = $light # used for rotating all
@onready var light_occluder_2d: LightOccluder2D = $light/LightOccluder2D
@onready var light_occluder_2d_2: LightOccluder2D = $light/LightOccluder2D2
@onready var point_light_2d: PointLight2D = $light/PointLight2D


var look_at_position : Marker2D
var look_at_duration : float
@export var marker_list: Array[Marker2D] = []
@export var duration_list: Array[float] = []
@onready var look_at_timer: Timer = $lookAtTimer
var current_marker_index : int = 0

#light stuff
var target_rotation: float = 0.0
@export var rotation_speed: float = 5.0 # higher = faster


#kill player variables
var player_area: Area2D = null
@onready var kill_timer: Timer = $killTimer


func _ready() -> void:
	check_errors()
	if marker_list.size() == 1:
		look_at_marker(marker_list[0], 0)
	else:
		start_look_sequence()

func _process(delta: float) -> void:
	light.rotation = lerp_angle(light.rotation, target_rotation, delta * rotation_speed)

func look_at_marker(marker : Marker2D, duration : float) -> void:
	var dir: Vector2 = (marker.global_position - global_position).normalized()
	play_direction_animation(dir)
	target_rotation = dir.angle() - PI / 2
	
	if duration > 0:
		look_at_timer.wait_time = duration
		look_at_timer.start()
	else:
		look_at_timer.stop()

func start_look_sequence() -> void:
	if marker_list.is_empty():
		return
	
	current_marker_index = 0
	look_at_marker(marker_list[current_marker_index], duration_list[current_marker_index])

func play_direction_animation(dir: Vector2) -> void:
	var anim: String
	if abs(dir.x) > abs(dir.y):
		# horizontally
		if dir.x > 0:
			anim = "right"
		else:
			anim = "left"
	else:
		#vertically
		if dir.y > 0:
			anim = "down"
		else:
			anim = "up"
	
	animated_mask.play(anim)
	animated_body.play(anim)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		player_area = area
		kill_timer.start()
			

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		player_area = null
		kill_timer.stop()

func _on_timer_timeout() -> void:
	if player_area:
		if player_area.get_parent().can_kill_player():
			player_area.get_parent().kill_player()
			#speed = speed * 0.2
			kill_timer.stop()

func check_errors() -> void:
	if marker_list.is_empty():
		printerr("this enemy has no markers")
	if duration_list.is_empty():
		printerr("this enemy has no durations")
	if marker_list.size() != duration_list.size():
		printerr("list size does not match")


func _on_look_at_timer_timeout() -> void:
	current_marker_index += 1

	if current_marker_index >= marker_list.size():
		current_marker_index = 0  # loop back around

	var next_marker: Marker2D = marker_list[current_marker_index]
	var next_duration: float = duration_list[current_marker_index]
	look_at_marker(next_marker, next_duration)
