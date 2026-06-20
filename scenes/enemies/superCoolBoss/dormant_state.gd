extends State

func enter() -> void:
    player.sprite.play("idle")
    player.velocity = Vector2.ZERO

func exit() -> void:
    pass

func activate() -> void:
    state_machine.transition_to("IdleState")
