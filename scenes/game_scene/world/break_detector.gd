extends Area2D

func break_wall() -> void:
    get_parent().break_wall()
