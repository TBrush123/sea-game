extends State

@export var recovery_duration: float = 0.8

var timer: float = 0.0
func enter() -> void:
    timer = 0.0
    player.velocity.x = 0
    player.sprite.play("f_idle")

func physics_update(delta: float) -> void:
    player.apply_gravity(delta)
    player.move_and_slide()

    timer += delta

    if timer >= recovery_duration:
        state_machine.transition_to("PatrolState")