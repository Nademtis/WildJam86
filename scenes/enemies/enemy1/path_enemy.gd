extends PathFollow2D

#@onready var enemy_1: PathFollow2D = $"."
@onready var animated_mask: AnimatedSprite2D = $Animated_mask
@onready var animated_body: AnimatedSprite2D = $Animated_body

@export var speed: float = 100.0 # pixels per second
var last_position: Vector2


func _ready() -> void:
	last_position = global_position

func _process(delta: float) -> void:
	progress += speed * delta
	
	var direction: Vector2 = global_position - last_position
	
	if direction.length() > 0.1:
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
		area.get_parent().kill_player()
	pass # Replace with function body.
