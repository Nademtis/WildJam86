extends Node2D

@onready var animated_mask: AnimatedSprite2D = $Animated_mask
@onready var animated_body: AnimatedSprite2D = $Animated_body
@onready var light: Node2D = $light

var look_at_position : Marker2D

@export var marker_list: Array[Marker2D] = []
@export var duration_list: Array[float] = []

#kill player variables
var player_area: Area2D = null
@onready var timer: Timer = $Timer


func _ready() -> void:
	if marker_list.is_empty():
		printerr("this enemy has no markers")
	if duration_list.is_empty():
		printerr("this enemy has no durations")
	if marker_list.size() != duration_list.size():
		printerr("list size does not match")

func _process(_delta: float) -> void:
	pass


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
		timer.start()
			


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		player_area = null
		timer.stop()

func _on_timer_timeout() -> void:
	if player_area:
		if player_area.get_parent().can_kill_player():
			player_area.get_parent().kill_player()
			#speed = speed * 0.2
			timer.stop()
