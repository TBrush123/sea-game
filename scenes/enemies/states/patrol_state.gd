extends State

@export var patrol_distance: float = 200.0
var start_x: float
var direction: int = -1

func enter() -> void:
	await player.ready
	player.sprite.play("walk")
	start_x = player.global_position.x

func _end_alert_effects() -> void:
	var tween = create_tween().set_parallel(true).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(player.alert_sprite, "modulate:a", 0, 0.2).from(1)
	tween.tween_property(player.alert_sprite, "position", Vector2(0, -80), 0.2).from(Vector2(0, -50))

func physics_update(delta: float) -> void:
	player.velocity.x = direction * player.move_speed
	player.update_facing(direction)
	player.move_and_slide()

	if abs(player.global_position.x - start_x) > patrol_distance:
		direction *= -1

	if not player.is_on_floor():
		player.apply_gravity(delta)

	if player.detection_area.has_overlapping_bodies():
		for body in player.detection_area.get_overlapping_bodies():
			if body.is_in_group("player"):
				var tween = create_tween().set_parallel(true).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
				tween.tween_property(player.alert_sprite, "modulate:a", 1, 0.1).from(0)
				tween.tween_property(player.alert_sprite, "position", Vector2(0, -50), 0.1).from(Vector2(0, 0))
				player.alert_sfx.play()
				tween.tween_callback(func() -> void:
					_end_alert_effects()
					state_machine.transition_to("ChaseState")
				)
				return
