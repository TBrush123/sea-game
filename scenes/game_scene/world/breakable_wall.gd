class_name BreakableWall
extends StaticBody2D

@export var shake_amount: float = 10.0

@onready var sprite: Sprite2D = $Wall
@onready var collsion_shape: CollisionShape2D = $CollisionShape2D
@onready var break_detector: Area2D = $BreakDetector
@onready var break_particles: GPUParticles2D = $WallBreakParticles

func break_wall() -> void:
	if break_particles:
		break_particles.emitting = true
		break_particles.global_position = global_position

	HitStop.freeze(0.15, 0.1)
	get_viewport().get_camera_2d().shake(shake_amount)

	sprite.hide()
	collsion_shape.set_deferred("disabled", true)
	break_detector.set_deferred("monitoring", false)

	await get_tree().create_timer(3.5).timeout
	queue_free()
