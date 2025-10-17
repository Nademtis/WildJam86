extends PathFollow2D

@onready var animated_mask: AnimatedSprite2D = $Animated_mask
@onready var animated_body: AnimatedSprite2D = $Animated_body
@onready var light: Node2D = $light

@export var speed: float = 100.0
var last_position: Vector2

#kill player variables
var player_area: Area2D = null
@onready var timer: Timer = $Timer

#sfx
@onready var enemy_positional: AudioStreamPlayer2D = $enemyPositional


func _ready() -> void:
	enemy_positional.play()
	last_position = global_position

func _process(delta: float) -> void:
	progress += speed * delta
	
	var direction: Vector2 = global_position - last_position
	
	#light.look_at(direction) # this does not work
	
	if direction.length() > 0.1:
		
		#for rotation 
		var target_angle = direction.angle() - deg_to_rad(90)
		var rotation_speed = 10.0  # higher = snappier, lower = smoother
		light.rotation = lerp_angle(light.rotation, target_angle, rotation_speed * delta)
		
		play_direction_animation(direction.normalized())
	last_position = global_position

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
			speed = speed * 0.2
			timer.stop()
