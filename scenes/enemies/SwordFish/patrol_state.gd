extends State

@export var patrol_distance: float = 200.0
@export var lunge_cooldown: float = 3.0

var start_x: float
var direction: int = 1
var cooldown_timer: float = 0.0

func enter() -> void:
	#player.sprite.play("walk")
	start_x = player.global_position.x
	cooldown_timer = lunge_cooldown

func physics_update(delta: float) -> void:
	player.velocity.x = direction * player.move_speed
	player.update_facing(direction)
	player.move_and_slide()
	player.apply_gravity(delta)

	if abs(player.global_position.x - start_x) > patrol_distance:
		direction *= -1
		start_x = player.global_position.x

	cooldown_timer -= delta
	if cooldown_timer > 0.0:
		return


	if player.detection_area.has_overlapping_bodies():
		for body in player.detection_area.get_overlapping_bodies():
			if body.is_in_group("player"):
				if player.raycast.is_colliding():
					var first_hit = player.raycast.get_collider()
					if first_hit.is_in_group("player"):
						print("diiih")
						var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
						tween.tween_callback(func() -> void:
							state_machine.transition_to("TelegraphState")
						)
