extends State

@export var slam_speed: float = 180.0
@export var slam_duration: float = 0.5
@export var windup_time: float = 0.15

var timer: float = 0.0
var slam_direction: int = 1
var is_rushing: bool = false

func enter() -> void:
	player.sprite.play("idle")
	player.sprite.speed_scale = 2.0
	timer = 0.0
	is_rushing = false
	slam_direction = player.facing_direction
	player.slam_hitbox.monitoring = true
	player.velocity.x = 0

func exit() -> void:
	player.slam_hitbox.monitoring = false
	player.velocity.x = 0

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move_and_slide()
	timer += delta

	if not is_rushing:
		if timer >= windup_time * player.get_attack_speed_multiplier():
			is_rushing = true
			timer = 0.0
			player.slam_hitbox.monitoring = true
			get_viewport().get_camera_2d().shake(4.0)
		return

	player.velocity.x = slam_direction * slam_speed * player.get_speed_multiplier()

	var hit_wall = false
	for i in player.get_slide_collision_count():
		if abs(player.get_slide_collision(i).get_normal().x) > 0.5:
			hit_wall = true
			break
	
	if hit_wall:
		player.velocity.x = 0
		get_viewport().get_camera_2d().shake(20.0)
		HitStop.freeze(0.1, 0.04)
		state_machine.transition_to("WalkState")
		return
	
	if timer >= slam_duration:
		state_machine.transition_to("WalkState")
