extends State


func enter() -> void:
	player.sprite.play("fall")

func physics_update(delta: float) -> void:
	player.velocity.y += player.gravity * delta

	var direction = Input.get_axis("move_left", "move_right")
	
	if Input.is_action_just_pressed("dash") and player.can_dash and \
		MutationManager.has_mutation(MutationManager.mutation_type.DASH):
			state_machine.transition_to("DashState")
			return
	if Input.is_action_pressed("jump") and player.can_jump():
		player.coyote_timer = 0.0
		state_machine.transition_to("JumpState")
		return
	
	if Input.is_action_pressed("basic_attack"):
		state_machine.transition_to("AttackState")
		return
	
	player.velocity.x = direction * player.speed
	player.move_and_slide()

	if player.is_on_floor():
		if direction != 0:
			state_machine.transition_to("MoveState")
		else:
			state_machine.transition_to("IdleState")
