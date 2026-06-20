extends State

@export var charge_speed_penalty: float = 0.1
@export var lunge_duration: float = 0.5
@export var min_charge_to_fire: float = 0.5
@export var windup_delay: float = 0.15

var charge_time: float = 0.0
var is_charging: bool = true
var lunge_timer: float = 0.0
var current_damage: int = 0
var just_entered: bool = true
var full_charge_tween: Tween = null
var _frame_watcher: Callable

func enter() -> void:
	player.sprite.play("tongue")
	player.sprite.pause()
	charge_time = 0.0
	is_charging = true
	player.velocity.x = 0
	just_entered = true
	full_charge_tween = null

func exit() -> void:
	_stop_blink()
	player.tongue_hitbox.disable()
	player.tongue_sprite.hide()
	lunge_timer = 0.0
	charge_time = 0.0

func physics_update(delta: float) -> void:
	player.apply_gravity(delta, 0.5)

	if is_charging:
		charge_time = min(charge_time + delta, player.tongue_max_charge_time)

		var direction = Input.get_axis("move_left", "move_right")
		player.velocity.x = direction * player.speed * charge_speed_penalty
		player.update_facing(direction)
		player.move_and_slide()

		var charge_ratio = charge_time / player.tongue_max_charge_time

		if charge_time < player.tongue_max_charge_time:
			player.sprite.modulate = Color(1.0, 1.0 - charge_ratio * 0.5, 1.0 - charge_ratio * 0.5)
		elif full_charge_tween == null:
			full_charge_tween = player.create_tween().set_loops()
			full_charge_tween.tween_property(player, "modulate:v", 15, 0.1)
			full_charge_tween.tween_property(player, "modulate:v", 1, 0.1)

		var released = not just_entered and (Input.is_action_just_released("tongue_attack") or not Input.is_action_pressed("tongue_attack"))

		if released and charge_time >= min_charge_to_fire:
			_stop_blink()
			_gallop_on()
		elif released:
			_stop_blink()
			await get_tree().create_timer(min_charge_to_fire - charge_time).timeout
			if is_charging:
				_gallop_on()

		just_entered = false
		return
	else:
		lunge_timer += delta
		player.move_and_slide()

		if lunge_timer < lunge_duration:
			return

		if player.is_on_floor():
			state_machine.transition_to("IdleState")
		else:
			state_machine.transition_to("FallState")
func _stop_blink() -> void:
	if full_charge_tween:
		full_charge_tween.kill()
		full_charge_tween = null
	player.modulate = Color.WHITE

func _gallop_on() -> void:
	is_charging = false
	lunge_timer = 0.0
	player.sprite.modulate = Color.WHITE

	var charge_ratio = charge_time / player.tongue_max_charge_time
	current_damage = lerp(player.tongue_min_damage, player.tongue_max_damage, charge_ratio)

	player.tongue_hitbox.damage = current_damage
	player.tongue_hitbox.can_break_walls = charge_ratio >= 0.95

	var max_reveal = lerp(0.3, 1.0, charge_ratio)
	var direction_sign = player.facing_direction

	var base_sprite_position_x = player.tongue_sprite.position.x
	var base_hitbox_position_x = player.tongue_hitbox.position.x
	var max_forward_offset = lerp(150.0, 300.0, charge_ratio)

	var collision_shape: CollisionShape2D = player.tongue_hitbox.get_node("CollisionShape2D")
	var shape: RectangleShape2D = collision_shape.shape
	var min_size = Vector2(300, 80)
	var max_size = Vector2(600, 80)
	shape.size = lerp(min_size, max_size, charge_ratio)


	player.sprite.play()
	player.tongue_sprite.hide()
	player.tongue_hitbox.disable()

	_frame_watcher = func():
		if player.sprite.frame >= 2:
			player.tongue_sprite.show()
			player.tongue_sprite.position.x = base_sprite_position_x
			player.tongue_hitbox.position.x = base_hitbox_position_x
			player.tongue_hitbox.enable()
			_launch_tongue(base_sprite_position_x, base_hitbox_position_x,
				direction_sign, max_forward_offset, charge_ratio)

			if player.sprite.frame_changed.is_connected(_frame_watcher):
				player.sprite.frame_changed.disconnect(_frame_watcher)
	player.sprite.frame_changed.connect(_frame_watcher)

func _launch_tongue(base_sprite_x: float, base_hitbox_x: float,
						direction_sign: int, max_forward_offset: float, charge_ratio: float) -> void:
	var extend_time = lerp(0.18, 0.08, charge_ratio)
	var retract_time = 0.15

	var tween = player.tongue_sprite.create_tween().set_parallel(true)

	tween.tween_property(
		player.tongue_sprite, "position:x",
		base_sprite_x + direction_sign * max_forward_offset, extend_time
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		player.tongue_hitbox, "position:x",
		base_hitbox_x + direction_sign * max_forward_offset, extend_time
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	tween.chain().tween_interval(0.06)

	await tween.finished

	var retract_tween = player.tongue_sprite.create_tween().set_parallel(true)

	retract_tween.tween_property(
		player.tongue_sprite, "position:x", base_sprite_x , extend_time)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).from(base_sprite_x + direction_sign * max_forward_offset)

	retract_tween.tween_property(
		player.tongue_hitbox, "position:x", base_hitbox_x , extend_time)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).from(base_hitbox_x + direction_sign * max_forward_offset * 5)

	retract_tween.chain().tween_callback(func():
		player.tongue_hitbox.disable()
		player.tongue_sprite.hide())

	retract_tween.play()
