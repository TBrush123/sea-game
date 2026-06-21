extends Sprite2D

var target_button: Button = null

func _process(delta: float) -> void:
	if target_button != null:
		var button_center = target_button.global_position + (target_button.size / 2)
		global_rotation = lerp_angle(global_rotation, global_position.angle_to_point(button_center) + 0.2, 0.1)
