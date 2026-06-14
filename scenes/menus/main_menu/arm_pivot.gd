extends Node2D


func _process(_delta: float) -> void:
    
    var mouse_pos = get_global_mouse_position()
    var dir = (mouse_pos - global_position).normalized()
    var target_angle = dir.angle() + (-PI/18)

    rotation = target_angle
    queue_redraw()

    var cos_angle = abs(cos(rotation))
    var scale_x = lerp(0.3, 1.0, cos_angle)
    scale = Vector2(-scale_x, 1.0)

func _draw():
    var mouse_local = to_local(get_global_mouse_position())
    draw_line(Vector2.ZERO, mouse_local, Color.RED, 2.0)