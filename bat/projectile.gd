class_name Projectile
extends KinematicBody2D

signal collided(other)

export (Vector2) var direction: Vector2 = Vector2.UP
export (float) var speed: float = 100.0


func _physics_process(delta):
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		emit_signal("collided", collision.collider)
		direction = direction.bounce(collision.normal)
