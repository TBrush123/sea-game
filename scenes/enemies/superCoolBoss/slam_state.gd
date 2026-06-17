extends State

@export var slam_speed: float = 180.0
@export var slam_duration: float = 0.5

var timer: float = 0.0

func enter() -> void:
	#player.sprite.play("slam")
	timer = 0.0
	player.slam_hitbox.monitoring = true
	player.velocity.x = player.facing_direction * slam_speed

func exit() -> void:
	player.slam_hitbox.monitoring = false
	player.velocity.x = 0

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move_and_slide()
	timer += delta

	var hit_wall = false
	for i in player.get_slide_collision_count():
		if abs(player.get_slide_collision(i).get_normal().x) > 0.5:
			hit_wall = true
			break
	if hit_wall or timer >= slam_duration:
		get_viewport().get_camera_2d().shake(20.0)
		HitStop.freeze(0.08, 0.05)
		state_machine.transition_to("IdleState")
