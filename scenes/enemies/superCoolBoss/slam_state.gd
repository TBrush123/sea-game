extends State

@export var slam_speed: float = 180.0
@export var slam_duration: float = 0.5

var timer: float = 0.0
var slam_direction: int = 1

func enter() -> void:
	player.sprite.play("attack1")
	timer = 0.0
	slam_direction = player.facing_direction
	player.slam_hitbox.monitoring = true
	player.velocity.x = player.facing_direction * slam_speed * player.get_speed_multiplier()

func exit() -> void:
	player.slam_hitbox.monitoring = false
	player.velocity.x = 0

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.velocity.x = slam_speed * player.get_speed_multiplier()
	player.move_and_slide()
	timer += delta

	var hit_wall = false
	for i in player.get_slide_collision_count():
		if abs(player.get_slide_collision(i).get_normal().x) > 0.5:
			hit_wall = true
			break
	if hit_wall:
		get_viewport().get_camera_2d().shake(20.0)
		HitStop.freeze(0.08, 0.05)
		state_machine.transition_to("WalkState")
		return

	if timer >= slam_duration:
		state_machine.transition_to("WalkState")
		return

