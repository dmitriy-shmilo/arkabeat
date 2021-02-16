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
	ACTIVITY
}

export (ORGAN_TYPE) var organ_type = ORGAN_TYPE.NONE

onready var _sprite: Sprite = $Sprite
onready var _powerup_tween: Tween = $PowerupTween
onready var _powerup: Sprite = $Powerup


func _ready():
	_sprite.region_rect.position.y = _get_sprite_frame() * 32


func show_powerup(powerup):
	_powerup.visible = true
	_powerup_tween.interpolate_property(_powerup, "position", \
		Vector2(0, 0), Vector2(0, -30), 0.4, \
		Tween.TRANS_CUBIC, Tween.EASE_OUT)
	_powerup_tween.start()
	yield(_powerup_tween, "tween_all_completed")
	_powerup.visible = false


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
