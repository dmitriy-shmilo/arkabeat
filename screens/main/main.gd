extends Node2D

const Organ = preload("res://organ/organ.gd")

const SPEEDUP_AMOUNT = 5.0
const BAT_Y_ALLOWANCE = 50.0
const PauseScene = preload("res://screens/settings/settings.tscn")
const LooseStream = preload("res://screens/main/loose.wav")

signal score_changed(new_score)
signal lives_changed(new_lives)
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
var _lives: int = 3

var _resources: Dictionary = {
	Organ.RESOURCE_TYPE.OXYGEN : 0,
	Organ.RESOURCE_TYPE.NUTRITION : 0,
	Organ.RESOURCE_TYPE.ENERGY : 0,
}


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	emit_signal("lives_changed", _lives)


func _unhandled_key_input(event: InputEventKey):
	if event.is_action_released("pause"):
		get_tree().set_input_as_handled()
		_settings.visible = true
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		var position = (event as InputEventMouseMotion).position
		position.y = clamp(_bat.position.y + event.relative.y, \
			get_viewport_rect().size.y - BAT_Y_ALLOWANCE, \
			get_viewport_rect().size.y)
		position.x = clamp(position.x, \
			0, get_viewport_rect().size.x)
		_bat.position = position
		return


func _on_Projectile_collided(other):
	if other == _floor:
		_lives -= 1
		emit_signal("lives_changed", _lives)
		_audio.stream = LooseStream
		_audio.play()

		if _lives <= 0:
			_projectile.queue_free()
			yield(_audio, "finished")
			PersistedSettings.last_score = _score
			if _score > PersistedSettings.best_score:
				PersistedSettings.best_score = _score

			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().change_scene("res://screens/game_over/game_over.tscn")
	elif other.get_parent() is Organ:
		var organ = (other.get_parent() as Organ)
		organ.get_hit()
		
		if organ.consumed_resource != Organ.RESOURCE_TYPE.NONE \
			and _resources[organ.consumed_resource] > 0:
			organ.consume_if_needed(organ.consumed_resource)
			_score += 1
			emit_signal("score_changed", _score)
			_resources[organ.consumed_resource] = 0
			emit_signal("resource_lost", organ.consumed_resource)
		
		var res = organ.retrieve_resource()
		
		if res == Organ.RESOURCE_TYPE.NONE:
			return
		
		if _resources[res] > 0:
			return

		_score += 1
		emit_signal("score_changed", _score)
		_resources[res] = 1
		emit_signal("resource_gained", res)
	elif other.get_parent() is Bat:
		_projectile.speed_up(SPEEDUP_AMOUNT)


func _on_Settings_back_pressed():
	_settings.visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
