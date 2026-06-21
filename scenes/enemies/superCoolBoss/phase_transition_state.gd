extends State

@export var zoom_in_amount: Vector2 = Vector2(0.3, 0.3)
@export var zoom_duration: float = 0.8
@export var slam_count: int = 10
@export var initial_slam_interval: float = 0.6
@export var slam_speed_increase: float = 0.06
@export var toss_speed: float = 400.0
@export var toss_height: float = -500.0
@export var shockwave_scene: PackedScene

var original_zoom: Vector2
var camera: Camera2D
var slam_index: int = 0
var phase: String = "zoom"
var timer: float = 0.0
var current_slam_interval: float = 0.0
var toss_direction: int = 1
var is_falling: bool = false
var player_ref: Node = null

func enter() -> void:
	player.velocity = Vector2.ZERO
	slam_index = 0
	phase = "zoom"
	timer = 0.0
	current_slam_interval = initial_slam_interval
	is_falling = false

	player_ref = get_tree().get_first_node_in_group("player")
	player_ref.is_invincible = true
	player_ref.set_movement_locked(true)
	player_ref.invincibility_timer = 9999.0

	camera = get_viewport().get_camera_2d()
	original_zoom = camera.zoom
	camera.set_target(player)
	
	player.contact_damage.monitoring = false

	var red_tween = player.create_tween()
	red_tween.tween_property(player.sprite, "modulate", Color(2.0, 0.3, 0.3), zoom_duration)

	var zoom_tween = camera.create_tween()
	zoom_tween.tween_property(camera, "zoom", zoom_in_amount, zoom_duration) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
func exit() -> void:
	var zoom_tween = camera.create_tween()
	zoom_tween.tween_property(camera, "zoom", original_zoom, 0.4) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	player.contact_damage.monitoring = true
	player.sprite.modulate = Color(1.2, 0.6, 0.6)
	player_ref.is_invincible = false
	player_ref.invincibility_timer = 0.0
	player_ref.set_movement_locked(false)

func physics_update(delta: float) -> void:
	timer += delta

	match phase:
		"zoom":
			player.velocity.x = 0
			player.apply_gravity(delta)
			player.move_and_slide()

			if timer >= zoom_duration:
				phase = "toss"
				timer = 0.0
				_start_toss()
		"toss":
			player.apply_gravity(delta)
			player.move_and_slide()

			if player.is_on_floor() and is_falling:
				_on_slam_landed()

		"finish":
			pass

func _start_toss() -> void:
	toss_direction = -1
	player.velocity.x = toss_direction * toss_speed
	player.velocity.y = toss_height
	player.update_facing(toss_direction)
	is_falling = false

	HitStop.freeze(0.1, 0.05)
	camera.shake(8.0)

	if player_ref and is_instance_valid(player_ref):
		player_ref.fling(Vector2(-toss_direction * 800.0, -400.0))

	get_tree().create_timer(0.15).timeout.connect(func(): is_falling = true)

func _on_slam_landed() -> void:
	slam_index += 1
	is_falling = false

	var shake_amount = slam_index * 2.0
	camera.shake(shake_amount)
	HitStop.freeze(0.05 + slam_index * 0.01, 0.08)
	player.sprite.play("attack1")
	player.sprite.speed_scale += 0.1 * 1 / current_slam_interval
	_spawn_slam_shockwaves()

	if slam_index >= slam_count:
		phase = "finish"
		_finish_transition()
		return
	
	current_slam_interval -= slam_speed_increase
	var wait = max(current_slam_interval, 0.1)

	player.sprite.play("idle")
	player.velocity.x = 0

	await get_tree().create_timer(wait).timeout
	if phase == "finish":
		return
	
	toss_direction *= -1
	player.velocity.x = toss_direction * (toss_speed + slam_index * 50.0)
	player.velocity.y = toss_height * (1.0 + slam_index * 0.1)
	player.update_facing(toss_direction)
	is_falling = false

	await get_tree().create_timer(0.1).timeout
	is_falling = true

func _spawn_slam_shockwaves() -> void:
	get_viewport().get_camera_2d().shake(30.0)
	HitStop.freeze(0.08, 0.05)

	for dir in [-1, 1]:
		var shockwave = shockwave_scene.instantiate()
		shockwave.global_position = player.shockwave_marker.global_position
		shockwave.direction = dir
		shockwave.speed *= player.get_speed_multiplier()
		get_tree().current_scene.add_child(shockwave)

func _finish_transition() -> void:
	player.velocity = Vector2.ZERO
	player.sprite.play("idle")

	await get_tree().create_timer(1).timeout

	var flash_tween = player.sprite.create_tween()
	flash_tween.tween_property(player.sprite, "modulate", Color.WHITE, 0.1)
	flash_tween.tween_property(player.sprite, "modulate", Color(1.2, 0.6, 0.6), 0.3)

	HitStop.freeze(0.15, 0.02)
	camera.shake(20.0)

	await flash_tween.finished

	camera.set_target(null)
	camera.global_position = Vector2(44336.0, 5394.0)
	state_machine.transition_to("WalkState")
