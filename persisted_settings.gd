extends Node

const MAX_VOLUME = 100.0

var best_score = 0
var last_score = 0
var sfx_volume: float = MAX_VOLUME setget set_sfx_volume
var music_volume: float = MAX_VOLUME setget set_music_volume
var enable_particles = true

var _sfx_bus
var _music_bus

func _ready():
	_sfx_bus = AudioServer.get_bus_index("Sfx")
	_music_bus = AudioServer.get_bus_index("Music")


func set_sfx_volume(value: float):
	value = clamp(value, 0, MAX_VOLUME)
	sfx_volume = value
	_set_volume(_sfx_bus, value)


func set_music_volume(value: float):
	value = clamp(value, 0, MAX_VOLUME)
	music_volume = value
	_set_volume(_music_bus, value)


func _set_volume(bus_idx: int, value: float):
	AudioServer.set_bus_mute(bus_idx, sfx_volume == 0)
	AudioServer.set_bus_volume_db(bus_idx, lerp(-40.0, 0, value / 100.0))
