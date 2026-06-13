extends State


func enter() -> void:
	player.sprite.play("move")

func physics_update(delta: float) -> void:
	var direction = Input.get_axis("move_left", "move_right")

	if Input.is_action_just_pressed("dash") and player.can_dash and \
		MutationManager.has_mutation(MutationManager.mutation_type.DASH):
			state_machine.transition_to("DashState")
			return

	if Input.is_action_pressed("jump"):
		state_machine.transition_to("JumpState")
		return
	
	if not player.is_on_floor():
		state_machine.transition_to("FallState")
		return

	if Input.is_action_pressed("basic_attack"):
		state_machine.transition_to("AttackState")
		return

	if direction == 0:
		state_machine.transition_to("IdleState")
		return

	player.velocity.x = direction * player.speed
	player.update_facing(direction)
	player.move_and_slide()
