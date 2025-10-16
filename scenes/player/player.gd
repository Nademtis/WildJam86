extends CharacterBody2D
class_name Player

@export var max_speed: float = 60
@export var acceleration: float = 8
@export var deceleration: float = 60

#used for die animation
var can_move = true

var is_mask_equipped : bool
@export var mask_max_time: float = PlayerStats.max_mask_time
var mask_timer: float = 0.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# used for player die anim
@onready var animation_player: AnimationPlayer = $dieanim/AnimationPlayer
@onready var dieanim: Node2D = $dieanim
@onready var slealth: Node2D = $slealth

func _ready() -> void:
	dieanim.visible = false

func _process(delta: float) -> void:
	if PlayerStats.mask_unlocked:
		mask_logic(delta)

func mask_logic(delta: float) -> void:
		if Input.is_action_pressed("mask"):
			is_mask_equipped = true
		else:
			is_mask_equipped = false
		
		if is_mask_equipped:
			mask_timer += delta
		elif !is_mask_equipped and velocity.length() < 5.0: # yes mask and standing still
			mask_timer -= delta
		
		mask_timer = clamp(mask_timer, 0.0, mask_max_time) # so mask value not negative
		
		if mask_timer >= mask_max_time:
			kill_player()
		#print(mask_timer)

func _physics_process(delta: float) -> void:
	if can_move:
		move_player(delta) #also animates
	move_and_slide()


func move_player(delta : float) -> void:
	var input_vector = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
		).normalized()
	
	if is_mask_equipped:
		anim_player_mask(input_vector)
	else:
		anim_player_no_mask(input_vector)
	
		# acceleration
	if input_vector != Vector2.ZERO:
		velocity = lerp(velocity, input_vector * max_speed, acceleration * delta)
	else: #deceleration
		velocity = lerp(velocity, input_vector * max_speed, deceleration * delta)

func can_kill_player() -> bool:
	if slealth.is_hidden or is_mask_equipped:
		#print("not killing since mask or hidden")
		return false
	else:
		return true

func kill_player() -> void:
	can_move = false
	velocity = Vector2.ZERO
	mask_timer = 0

	animated_sprite_2d.visible = false
	dieanim.visible = true
	animation_player.play("die_anim")
	
	#shake behavior
	var shake_time := 1
	var elapsed := 0.0 # don't change
	var amplitude := 0.5

	while elapsed < shake_time:
		var offset_x := sin(elapsed * 50.0) * amplitude
		position.x += offset_x
		await get_tree().process_frame
		position.x -= offset_x
		elapsed += get_process_delta_time()
	
	#await get_tree().create_timer(1).timeout
	
	Events.emit_signal("restart_level")

func anim_player_no_mask(input_vector) -> void:
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
		animated_sprite_2d.play("idle")

func anim_player_mask(input_vector) -> void:
	if input_vector != Vector2.ZERO:
		if abs(input_vector.x) > abs(input_vector.y):
			if input_vector.x > 0:
				animated_sprite_2d.play("mask_walk_right")
			else:
				animated_sprite_2d.play("mask_walk_left")
		else:
			if input_vector.y > 0:
				animated_sprite_2d.play("mask_walk_down")
			else:
				animated_sprite_2d.play("mask_walk_up")
	else:
		animated_sprite_2d.play("mask_idle")
