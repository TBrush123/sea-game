extends State

func enter() -> void:
	player.sprite.play("hurt")
	pass

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.velocity.x = move_toward(player.velocity.x, 0, 600 * delta)
	player.move_and_slide()

	if not player.sprite.is_playing():
		if player.is_on_floor():
			state_machine.transition_to("IdleState")
		else:
			state_machine.transition_to("FallState")
