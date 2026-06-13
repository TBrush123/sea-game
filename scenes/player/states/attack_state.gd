extends State

const SPEED = 150.0

func enter() -> void:
	player.sprite.play("attack")
	player.basic_attack_hitbox.enable()
	player.velocity.x = 0
	player.velocity.y = 0

func exit() -> void:
	player.basic_attack_hitbox.disable()

func physics_update(delta: float) -> void:
	player.apply_gravity(delta, 0.5)

	if not player.sprite.is_playing():
		if Input.get_axis("move_left", "move_right") != 0:
			state_machine.transition_to("MoveState")
		else:
			state_machine.transition_to("IdleState")
			
	player.move_and_slide()
