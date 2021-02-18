class_name Bat
extends KinematicBody2D

const Beat1 = preload("res://bat/beat1.wav")
const Beat2 = preload("res://bat/beat2.wav")

onready var _sprite: Sprite = $Sprite
onready var _audio: AudioStreamPlayer = $Audio
onready var _beat_sprite: Sprite = $BeatSprite
onready var _tween: Tween = $Tween
onready var _animation_player: AnimationPlayer = $AnimationPlayer

var desired_position

var _current_beat = 1
var _velocity = Vector2.ZERO

func _ready():
	desired_position = global_position


func _physics_process(delta):
	_velocity = (desired_position - global_position).normalized() * 640
	if (desired_position - global_position).length() < 10:
		global_position = desired_position
	else:
		move_and_collide(_velocity * delta)


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
		
		_tween.interpolate_property(_sprite, "scale", Vector2(1.0, 1.0), \
			Vector2(0.8, 0.8), .1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.0)
		_tween.interpolate_property(_sprite, "scale", Vector2(1.0, 1.0), \
			Vector2(1.3, 1.3), .1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.1)
		_tween.interpolate_property(_sprite, "scale", Vector2(1.3, 1.3), \
			Vector2(1.0, 1.0), .1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.2)
		_tween.start()
		_animation_player.play("Hit")
		
