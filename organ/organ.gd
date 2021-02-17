class_name Organ
extends Node2D


enum ORGAN_TYPE {
	NONE,
	LEFT_LUNG,
	RIGHT_LUNG,
	LEFT_KIDNEY,
	RIGHT_KIDNEY,
	BRAIN,
	LIVER,
	STOMACH,
}

enum RESOURCE_TYPE {
	NONE,
	OXYGEN,
	NUTRITION,
	ENERGY,
}

const HitSounds = [ 
		preload("res://organ/hit1.wav"),
		preload("res://organ/hit2.wav")
]

export (ORGAN_TYPE) var organ_type = ORGAN_TYPE.NONE
export (RESOURCE_TYPE) var provided_resource = RESOURCE_TYPE.NONE
export (RESOURCE_TYPE) var consumed_resource = RESOURCE_TYPE.NONE

onready var _sprite: Sprite = $Sprite
onready var _resource_tween: Tween = $ResourceTween
onready var _consumed_resource_tween: Tween = $ConsumedResourceTween
onready var _hit_tween: Tween = $HitTween
onready var _resource_sprite: Sprite = $ResourceSprite
onready var _consumed_resource_sprite: Sprite = $ConsumedResourceSprite
onready var _animation_player: AnimationPlayer = $AnimationPlayer
onready var _sleeping_indicator: AnimatedSprite = $SleepingIndicator
onready var _audio: AudioStreamPlayer = $Audio

func _ready():
	# TODO: clean up magic numbers
	_sprite.region_rect.position.y = _get_sprite_frame() * 32
	_resource_sprite.region_rect.position.x = _get_resource_frame(provided_resource) * 16
	_consumed_resource_sprite.region_rect.position.x = _get_resource_frame(consumed_resource) * 16


func consume_if_needed(resource):
	if resource == consumed_resource:
		_show_consumed_resource()
		return true
	return false


func retrieve_resource():
	if provided_resource != RESOURCE_TYPE.NONE:
		_show_provided_resource()
	return provided_resource


func get_hit():
	_animation_player.play("Hit")
	_hit_tween.interpolate_property(_sprite, "scale", Vector2(1.0, 1.0), \
			Vector2(0.9, 0.9), .1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.0)
	_hit_tween.interpolate_property(_sprite, "scale", Vector2(1.0, 1.0), \
			Vector2(1.2, 1.2), .1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.1)
	_hit_tween.interpolate_property(_sprite, "scale", Vector2(1.2, 1.2), \
		Vector2(1.0, 1.0), .1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.2)
	_hit_tween.start()
	if not _audio.playing:
		_audio.stream = HitSounds[randi() % HitSounds.size()]
		_audio.play()


func play_hit_frame():
	_sprite.region_rect.position.x = 32


func play_normal_frame():
	_sprite.region_rect.position.x = 0
	

func play_sleep_frame():
	_sprite.region_rect.position.x = 64


func _show_provided_resource():
	_resource_sprite.visible = true
	_resource_tween.interpolate_property(_resource_sprite, "position", \
		Vector2(0, 0), Vector2(0, 4), 0.2, \
		Tween.TRANS_CUBIC, Tween.EASE_OUT)
	_resource_tween.interpolate_property(_resource_sprite, "position", \
		Vector2(0, 4), Vector2(0, -28), 0.2, \
		Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.2)
	_resource_tween.start()
	yield(_resource_tween, "tween_all_completed")
	_resource_sprite.visible = false


func _show_consumed_resource():
	_consumed_resource_sprite.visible = true
	_consumed_resource_tween.interpolate_property(_consumed_resource_sprite, \
	 	"scale", Vector2(1.0, 1.0), Vector2(1.3, 1.3), 0.2, \
		Tween.TRANS_CUBIC, Tween.EASE_OUT)
	_consumed_resource_tween.interpolate_property(_consumed_resource_sprite, \
	 	"scale", Vector2(1.3, 1.3), Vector2(0.0, 0.0), 0.2, \
		Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.2)
	_consumed_resource_tween.start()
	yield(_consumed_resource_tween, "tween_all_completed")
	_consumed_resource_sprite.visible = false


func _get_sprite_frame():
	match organ_type:
		ORGAN_TYPE.NONE:
			return 0
		ORGAN_TYPE.BRAIN:
			return 1
		ORGAN_TYPE.STOMACH:
			return 2
		ORGAN_TYPE.RIGHT_KIDNEY:
			return 3
		ORGAN_TYPE.LEFT_KIDNEY:
			return 4
		ORGAN_TYPE.RIGHT_LUNG:
			return 5
		ORGAN_TYPE.LEFT_LUNG:
			return 6
		ORGAN_TYPE.LIVER:
			return 7


func _get_resource_frame(resource):
	match resource:
		RESOURCE_TYPE.OXYGEN:
			return 0
		RESOURCE_TYPE.ENERGY:
			return 1
		RESOURCE_TYPE.NUTRITION:
			return 2
	return -1
