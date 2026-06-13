extends Node

func freeze(duration: float = 0.06, scale = 0.05) -> void:
    Engine.time_scale = scale
    await get_tree().create_timer(duration, true, false, true).timeout
    Engine.time_scale = 1.0