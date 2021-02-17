extends Node2D

const Organ = preload("res://organ/organ.gd")

const SPEEDUP_AMOUNT = 3.0
const BAT_Y_ALLOWANCE = 50.0
const PauseScene = preload("res://screens/settings/settings.tscn")
const LooseStream = preload("res://screens/main/loose.wav")

signal score_changed(new_score)
signal resource_lost(resource)
signal resource_gained(resource)

onready var _projectile: Projectile = $Projectile
onready var _bat: Bat = $Bat
onready var _floor = $Floor
onready var _ceiling = $Ceiling
onready var _left_wall = $LeftWall
onready var _right_wall = $RightWall
onready var _audio: AudioStreamPlayer = $Audio
onready var _settings = $CanvasLayer/GUI/Settings

var _score: int = 0
var _resources: Dictionary = {
	Organ.RESOURCE_TYPE.OXYGEN : 0,
	Organ.RESOURCE_TYPE.NUTRITION : 0,
	Organ.RESOURCE_TYPE.ENERGY : 0,
}


func _input(event):
	if event is InputEventMouseMotion:
		var position = (event as InputEventMouseMotion).position
		position.y = clamp(position.y, \
			get_viewport_rect().size.y - BAT_Y_ALLOWANCE, \
			get_viewport_rect().size.y)
		position.x = clamp(position.x, \
			0, get_viewport_rect().size.x)
		_bat.position = position
		return
		
	if event.is_action("pause"):
		_settings.visible = true
		get_tree().paused = true


func _on_Projectile_collided(other):
	_projectile.speed_up(SPEEDUP_AMOUNT)
	if other == _floor:
		_audio.stream = LooseStream
		_audio.play()
	elif other.get_parent() is Organ:
		var organ = (other.get_parent() as Organ)
		organ.get_hit()
		_score += 1
		emit_signal("score_changed", _score)
		
		if organ.consumed_resource != Organ.RESOURCE_TYPE.NONE \
			and _resources[organ.consumed_resource] > 0:
			_resources[organ.consumed_resource] = 0
			emit_signal("resource_lost", organ.consumed_resource)
		
		var res = organ.retrieve_resource()
		
		if res == Organ.RESOURCE_TYPE.NONE:
			return
		
		_resources[res] = 1
		emit_signal("resource_gained", res)


func _on_Settings_back_pressed():
	_settings.visible = false
	get_tree().paused = false
