extends Node

@onready var ambience_1: AudioStreamPlayer = $Ambience1
@onready var ambience_2: AudioStreamPlayer = $Ambience2

@onready var music_1: AudioStreamPlayer = $music1
@onready var music_1_drums: AudioStreamPlayer = $music1_drums

const MUSIC_BUS : String = "Music"

var MUSIC_BUS_INDEX : int

var LOW_PASS : AudioEffectLowPassFilter
var min_hz : float= 1200.0
var max_hz : float = 20000.0
var duration : float = 0.6

var PITCH_SHIFT : AudioEffectPitchShift
var pitch_scale_max : float = 1.0
var pitch_scale_min : float = 0.7


func _ready() -> void:
	MUSIC_BUS_INDEX = AudioServer.get_bus_index(MUSIC_BUS)
	
	LOW_PASS = AudioServer.get_bus_effect(MUSIC_BUS_INDEX, 0)
	#PITCH_SHIFT = AudioServer.get_bus_effect(MUSIC_BUS_INDEX, 1)
	
	Events.connect("is_hidden", in_bush_effects)
	start_sounds()

func start_sounds() -> void:
	#ambience
	ambience_1.play()
	ambience_2.play()
	
	#music
	music_1.play()
	music_1_drums.play()

func in_bush_effects(is_hidden : bool) -> void:
	#add_pitchShift(is_hidden)
	add_eq_filter(is_hidden)


func add_pitchShift(is_hidden : bool) -> void:
	if not PITCH_SHIFT:
		push_warning("pitchshift filter not found on music bus")
		return
	
	var target_pitch := pitch_scale_min if is_hidden else pitch_scale_max
	var tween := create_tween()
	tween.tween_property(PITCH_SHIFT, "pitch_scale", target_pitch, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func add_eq_filter(is_hidden : bool) -> void:
	if not LOW_PASS:
		push_warning("lowpas filter not found on music bus")
		return
	
	var target_hz := min_hz if is_hidden else max_hz
	
	var tween := create_tween()
	tween.tween_property(LOW_PASS, "cutoff_hz", target_hz, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
