extends State

@export var jump_cut_multiplier: float = 0.5

func enter() -> void:
    player.sprite.play("jump")
    player.velocity.y = player.jump_velocity
    player.coyote_timer = 0.0

func physics_update(delta: float) -> void:
    player.apply_gravity(delta)

    if Input.is_action_just_pressed("dash") and player.can_dash and \
        MutationManager.has_mutation(MutationManager.mutation_type.DASH):
            state_machine.transition_to("DashState")
            return
    if Input.is_action_just_released("jump") and player.velocity.y < 0:
        player.velocity.y *= jump_cut_multiplier

    var direction = Input.get_axis("move_left", "move_right")
    player.velocity.x = direction * player.speed
    player.move_and_slide()

    if Input.is_action_pressed("basic_attack"):
        state_machine.transition_to("AttackState")
        return

    if player.velocity.y >= 0:
        state_machine.transition_to("FallState")
    

