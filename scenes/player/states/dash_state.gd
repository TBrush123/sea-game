extends State

@export var dash_speed: float = 3000.0
@export var dash_duration: float = 0.18

var timer: float = 0.0
var dash_direction: int = 1
var was_in_air: bool = false

func enter() -> void:
	#player.sprite.play("dash")
	timer = 0.0
	was_in_air = not player.is_on_floor()

	player.is_invincible = true

	dash_direction = player.facing_direction
	player.velocity = Vector2(dash_direction * dash_speed, 0)

	player.dash_hitbox.enable()
	player.dash_particles.global_position = player.global_position
	player.dash_particles.emitting = true

	player.set_collision_mask_value(3, false)

	HitStop.freeze(0.04, 0.1)
	get_viewport().get_camera_2d().shake(6.0)

	player.can_dash = false

func exit() -> void:
	player.dash_hitbox.disable()
	player.dash_particles.emitting = false
	player.set_collision_mask_value(3, true)

	player.is_invincible = false

	get_tree().create_timer(player.dash_cooldown).timeout.connect(
		func(): player.can_dash = true
	)

func physics_update(delta: float) -> void:
	timer += delta

	player.velocity.x = dash_direction * dash_speed
	player.velocity.y = 0
	
	player.move_and_slide()

	if timer >= dash_duration:
		if player.is_on_floor():
			state_machine.transition_to("IdleState")
		else:
			state_machine.transition_to("FallState")
