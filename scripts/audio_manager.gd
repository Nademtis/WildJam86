extends Node

#remember to make changes to the stop_all_music() function if adding more music
@onready var ambience_1: AudioStreamPlayer = $Ambience1
@onready var ambience_2: AudioStreamPlayer = $Ambience2

@onready var music_1: AudioStreamPlayer = $music1
@onready var music_2: AudioStreamPlayer = $music2

@onready var music_3: AudioStreamPlayer = $music3
@onready var music_3_drums: AudioStreamPlayer = $music3_drums

var current_level : int = 0
var max_level : int = 4

const MUSIC_BUS : String = "Music"
var MUSIC_BUS_INDEX : int

var LOW_PASS : AudioEffectLowPassFilter
var min_hz : float= 1200.0
var max_hz : float = 20000.0
var duration : float = 0.6




func _ready() -> void:
	MUSIC_BUS_INDEX = AudioServer.get_bus_index(MUSIC_BUS)
	
	#LOW_PASS = AudioServer.get_bus_effect(MUSIC_BUS_INDEX, 0)
	#PITCH_SHIFT = AudioServer.get_bus_effect(MUSIC_BUS_INDEX, 1)
	
	Events.connect("is_hidden", in_bush_effects)
	Events.connect("level_up_music", level_up_music)
	start_sounds()

func start_sounds() -> void:
	#ambience
	ambience_1.play()
	#ambience_2.play()
	
	#music
	#music_1.play()
	#music_1_drums.play()

func in_bush_effects(is_hidden : bool) -> void:
	#add_pitchShift(is_hidden)
	#add_eq_filter(is_hidden)
	pass

func level_up_music(level_up : bool) -> void:
	var new_level = clamp(current_level + (1 if level_up else -1), 0, max_level)
	if new_level == current_level:
		return # at the cap
	
	stop_all_music()
	
	match new_level:
		1:
			music_1.play()
		2:
			music_2.play()
		3:
			music_3.play()
		4:
			music_3.play()
			music_3_drums.play()
	
	current_level = new_level

func stop_all_music() -> void:
	music_1.stop()
	music_2.stop()
	music_3.stop()
	music_3_drums.stop()

func add_eq_filter(is_hidden : bool) -> void:
	if not LOW_PASS:
		push_warning("lowpas filter not found on music bus")
		return
	
	var target_hz := min_hz if is_hidden else max_hz
	
	var tween := create_tween()
	tween.tween_property(LOW_PASS, "cutoff_hz", target_hz, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
