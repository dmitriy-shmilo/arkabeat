class_name Bat
extends KinematicBody2D

onready var _audio: AudioStreamPlayer = $Audio
onready var _beat_sprite = $BeatSprite

const Beat1 = preload("res://bat/beat1.wav")
const Beat2 = preload("res://bat/beat2.wav")

var _current_beat = 1

func _ready():
	pass 


func _on_Projectile_collided(other):
	if other == self and not _audio.playing:
		var stream
		match _current_beat:
			1:
				stream = Beat1
				_current_beat = 2
			2:
				stream = Beat2
				_current_beat = 1
		_audio.stream = stream
		_audio.play()
		_beat_sprite.frame = 0
		_beat_sprite.play()
		
