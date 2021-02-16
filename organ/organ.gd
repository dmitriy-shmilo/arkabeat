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

export (ORGAN_TYPE) var organ_type = ORGAN_TYPE.NONE
export (RESOURCE_TYPE) var provided_resource = RESOURCE_TYPE.NONE
export (RESOURCE_TYPE) var consumed_resource = RESOURCE_TYPE.NONE

onready var _sprite: Sprite = $Sprite
onready var _resource_tween: Tween = $ResourceTween
onready var _resource_sprite: Sprite = $ResourceSprite


func _ready():
	# TODO: clean up magic numbers
	_sprite.region_rect.position.y = _get_sprite_frame() * 32
	_resource_sprite.region_rect.position.x = _get_resource_frame(provided_resource) * 16
	print(_get_resource_frame(_resource_sprite.region_rect.position.y))


func consume_if_needed(resource):
	return resource == consumed_resource


func retrieve_resource():
	if provided_resource != RESOURCE_TYPE.NONE:
		_show_resource()
	return provided_resource


func _show_resource():
	_resource_sprite.visible = true
	_resource_tween.interpolate_property(_resource_sprite, "position", \
		Vector2(0, 0), Vector2(0, -30), 0.4, \
		Tween.TRANS_CUBIC, Tween.EASE_OUT)
	_resource_tween.start()
	yield(_resource_tween, "tween_all_completed")
	_resource_sprite.visible = false


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
