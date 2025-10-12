extends CharacterBody2D

#enum MovementState{IDLE, WALKING, ATTACKING, DASHING}
#player movement
@export var max_speed: float = 75
@export var acceleration: float = 12
@export var deceleration: float = 95

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	move_player(delta) #also animates
	move_and_slide()


func move_player(delta : float) -> void:
	var input_vector = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
		).normalized()
	
	anim_player(input_vector)
	
		# apply acceleration when input is detected
	if input_vector != Vector2.ZERO:
		velocity = lerp(velocity, input_vector * max_speed, acceleration * delta)
	else: # Apply deceleration when no input is detected
		velocity = lerp(velocity, input_vector * max_speed, deceleration * delta)
	

func anim_player(input_vector) -> void:
	#TODO with mask
	if input_vector != Vector2.ZERO:
		if abs(input_vector.x) > abs(input_vector.y):
			if input_vector.x > 0:
				animated_sprite_2d.play("walk_right")
			else:
				animated_sprite_2d.play("walk_left")
		else:
			if input_vector.y > 0:
				animated_sprite_2d.play("walk_down")
			else:
				animated_sprite_2d.play("walk_up")
	else:
		animated_sprite_2d.play("idle")  # Default idle animation
