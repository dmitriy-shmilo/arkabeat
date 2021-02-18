class_name Projectile
extends KinematicBody2D

signal collided(other)

const INITIAL_SPEED = 100.0

export (Vector2) var direction: Vector2 = Vector2.ZERO setget set_direction
export (float) var speed: float = INITIAL_SPEED
export (float) var max_speed: float = 500.0

onready var _trail_particles = $TrailParticles

func speed_up(amount: float):
	speed = clamp(speed + amount, 0, max_speed)


func _physics_process(delta):
	if direction == Vector2.ZERO:
		return


	var collision = move_and_collide(direction * speed * delta)
	if collision:
		emit_signal("collided", collision.collider)
		direction = direction.bounce(collision.normal)


func set_direction(value):
	direction = value
	_trail_particles.visible = \
		value != Vector2.ZERO and PersistedSettings.enable_particles
	
