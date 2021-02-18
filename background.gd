tool
extends Node2D

export (bool) var allow_particles = true setget set_allow_particles

onready var _static_particles = $Particles

var _particle_emitters

func _ready():
	_particle_emitters = [$CloseMidParticles, $MidParticles]
	_update_particle_visibility()


func set_allow_particles(value):
	allow_particles = value
	_update_particle_visibility()


func _update_particle_visibility():
	if not is_inside_tree():
		return
	_static_particles.visible = not PersistedSettings.enable_particles \
		and not allow_particles
	for p in _particle_emitters:
		p.visible = PersistedSettings.enable_particles \
			and allow_particles \
			and not Engine.editor_hint


func _on_Settings_back_pressed():
	_update_particle_visibility()

