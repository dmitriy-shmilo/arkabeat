extends Node2D

enum GAME_STATE {
	PAUSE,
	LAUNCHING,
	PLAYING,
}

const Organ = preload("res://organ/organ.gd")

const SCORE_PER_LIFE = 100
const SPEEDUP_AMOUNT = 10.0
const BAT_Y_ALLOWANCE = 50.0
const PROJECTILE_OFFSET = 40.0

const PauseScene = preload("res://screens/settings/settings.tscn")
const LooseStream = preload("res://screens/main/loose.wav")
const OneUpStream = preload("res://screens/main/one_up.wav")
const WallHitStream = preload("res://screens/main/wall_hit.wav")

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
onready var _music: AudioStreamPlayer = $Music
onready var _settings = $CanvasLayer/GUI/Settings

var _score: int = 0 setget _set_score
var _lives: int = 3 setget _set_lives
var _state = GAME_STATE.LAUNCHING
var _mouse_captured = false

var _resources: Dictionary = {
	Organ.RESOURCE_TYPE.OXYGEN : 0,
	Organ.RESOURCE_TYPE.NUTRITION : 0,
	Organ.RESOURCE_TYPE.ENERGY : 0,
	Organ.RESOURCE_TYPE.SLOW_DOWN : 0,
}


func _ready():
	_try_capture_mouse()
	emit_signal("lives_changed", _lives)
	_music.stream_paused = false
	_music.play()


func _unhandled_key_input(event: InputEventKey):
	if event.is_action_released("pause"):
		get_tree().set_input_as_handled()
		_settings.visible = true
		get_tree().paused = true
		_release_mouse()


func _unhandled_input(event: InputEvent):
	if _state == GAME_STATE.LAUNCHING and event is InputEventMouseButton:
		_set_state(GAME_STATE.PLAYING)
	elif event is InputEventMouseMotion:
		var position = (event as InputEventMouseMotion).position
		if _mouse_captured:
			position = _bat.position + event.relative

		position.y = clamp(position.y, \
			get_viewport_rect().size.y - BAT_Y_ALLOWANCE, \
			get_viewport_rect().size.y)
		position.x = clamp(position.x, \
			0, get_viewport_rect().size.x)
		_bat.desired_position = position

		if _state == GAME_STATE.LAUNCHING:
			_projectile.position.x = _bat.position.x
			_projectile.position.y = _bat.position.y - PROJECTILE_OFFSET


func _set_state(new_state):
	_state = new_state
	match new_state:
		GAME_STATE.LAUNCHING:
			_projectile.position.x = _bat.position.x
			_projectile.position.y = _bat.position.y - PROJECTILE_OFFSET
			_projectile.direction = Vector2.ZERO
		GAME_STATE.PLAYING:
			_projectile.direction = Vector2.UP


func _set_score(new_score):
	_score = new_score
	if _score % SCORE_PER_LIFE == 0:
		_set_lives(_lives + 1)
		if not _audio.playing:
			_audio.stream = OneUpStream
			_audio.play()
	emit_signal("score_changed", _score)


func _set_lives(new_lives):
	_lives = new_lives
	emit_signal("lives_changed", _lives)


func _try_capture_mouse():
	if OS.has_feature("HTML5"):
		return
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_mouse_captured = true


func _release_mouse():
	if OS.has_feature("HTML5"):
		return
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_mouse_captured = false


func _on_Projectile_collided(other):
	if other == _left_wall \
		or other == _right_wall \
		or other == _ceiling:
		if not _audio.playing:
			_audio.stream = WallHitStream
			_audio.play()
	elif other == _floor:
		_set_state(GAME_STATE.LAUNCHING)
		_set_lives(_lives - 1)
		$ShakingCamera.shake()
		_projectile.speed = Projectile.INITIAL_SPEED

		if not _audio.playing:
			_audio.stream = LooseStream
			_audio.play()

		if _lives <= 0:
			_projectile.visible = false
			_projectile.direction = Vector2.ZERO
			yield(_audio, "finished")
			PersistedSettings.last_score = _score
			if _score > PersistedSettings.best_score:
				PersistedSettings.best_score = _score

			_release_mouse()
			get_tree().change_scene("res://screens/game_over/game_over.tscn")
	elif other is Bat:
		_projectile.speed_up(SPEEDUP_AMOUNT)
	elif other.get_parent() is Organ:
		var organ = (other.get_parent() as Organ)
		organ.get_hit()
		
		_projectile.speed_up(organ.speed_mod)
		
		if organ.consumed_resource != Organ.RESOURCE_TYPE.NONE \
			and _resources[organ.consumed_resource] > 0:
			organ.consume_if_needed(organ.consumed_resource)
			_set_score(_score + organ.score_mod)
			_resources[organ.consumed_resource] = 0
			emit_signal("resource_lost", organ.consumed_resource)
		
		var res = organ.retrieve_resource()
		
		if res == Organ.RESOURCE_TYPE.NONE:
			return
		
		if _resources[res] > 0:
			return

		_set_score(_score +  organ.score_mod)
		_resources[res] = 1
		emit_signal("resource_gained", res)


func _on_Settings_back_pressed():
	_settings.visible = false
	get_tree().paused = false
	_try_capture_mouse()


func _on_Settings_quit_pressed():
	_settings.visible = false
	get_tree().paused = false
	get_tree().change_scene("res://screens/title/title.tscn")
