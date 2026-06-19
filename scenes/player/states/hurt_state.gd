extends State

@export var hurt_duration: float = 0.1

var hurt_timer: float = 0.0

func enter() -> void:
	hurt_timer = hurt_duration

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.velocity.x = move_toward(player.velocity.x, 0, 600 * delta)
	player.move_and_slide()

	if hurt_timer > 0.0:
		hurt_timer -= delta
		return


	if player.is_on_floor():
		state_machine.transition_to("IdleState")
	else:
		state_machine.transition_to("FallState")
