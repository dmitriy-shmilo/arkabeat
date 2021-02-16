extends Node2D

const SPEEDUP_AMOUNT = 10.0
const BAT_Y_ALLOWANCE = 50.0
const LooseStream = preload("res://screens/main/loose.wav")

onready var _projectile: Projectile = $Projectile
onready var _bat: Bat = $Bat
onready var _floor = $Floor
onready var _ceiling = $Ceiling
onready var _left_wall = $LeftWall
onready var _right_wall = $RightWall
onready var _audio: AudioStreamPlayer = $Audio


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var position = (event as InputEventMouseMotion).position
		position.y = clamp(position.y, \
			get_viewport_rect().size.y - BAT_Y_ALLOWANCE, \
			get_viewport_rect().size.y)
		position.x = clamp(position.x, \
			0, get_viewport_rect().size.x)
		_bat.position = position


func _on_Projectile_collided(other):
	_projectile.speed_up(SPEEDUP_AMOUNT)
	if other == _floor:
		_audio.stream = LooseStream
		_audio.play()
	elif other.get_parent() is Organ:
		(other.get_parent() as Organ).show_powerup(null)
