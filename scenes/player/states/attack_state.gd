extends State

@export var windup_delay: float = 0.1
var attack_finished: bool = false

func enter() -> void:
	player.sprite.play("attack")
	player.velocity.x = 0
	player.velocity.y = 0

	enable_hitbox_delayed(player.basic_attack_hitbox, windup_delay)

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
