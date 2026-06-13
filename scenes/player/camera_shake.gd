extends Camera2D

var shake_strength: float = 0.0
var shake_decay: float = 10.0

func _process(delta: float) -> void:
    if shake_strength > 0:
        offset = Vector2(
            randf_range(-1 / zoom.x, 1 / zoom.y) * shake_strength,
            randf_range(-1 / zoom.x, 1 / zoom.y) * shake_strength
        )
        shake_strength = max(shake_strength - shake_decay * delta, 0)

    else:
        offset = Vector2.ZERO

func shake(amount: float = 4.0) -> void:
    shake_strength = amount