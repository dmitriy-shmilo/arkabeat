extends Node2D

export (bool) var allow_particles = true

onready var _static_particles = $Particles

var _particle_emitters

func _ready():
	_particle_emitters = [$CloseMidParticles, $MidParticles]
	_update_particle_visibility()


func _update_particle_visibility():
	_static_particles.visible = not PersistedSettings.enable_particles \
		and not allow_particles
	for p in _particle_emitters:
		p.visible = PersistedSettings.enable_particles and allow_particles


func _on_Settings_back_pressed():
	_update_particle_visibility()
