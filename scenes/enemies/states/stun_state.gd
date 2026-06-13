extends State

func enter() -> void:
    #player.sprite.play("stun")
    player.velocity.x = 0
    player.modulate = Color(0.6, 0.6, 1.0)

func exit() -> void:
    player.modulate = Color.WHITE

func physics_update(delta: float) -> void:
    player.apply_gravity(delta)
    player.move_and_slide()   