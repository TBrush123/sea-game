extends State

@export var lunge_speed: float = 1500.0
@export var lunge_duration: float = 1.0
@export var retract_duration: float = 0.6
@export var smoll_jump_power: float = -300.0


var timer: float = 0.0
var lunge_direction: int = 1
var retract_timer: float = 0.0
var is_dashing_forward: bool = false

func enter() -> void:
	timer = 0.0
	player.sprite.play("f_dash")
	player.sprite.stop()
	
	lunge_direction = player.facing_direction
	player.velocity.x = - lunge_speed * lunge_direction 
	player.velocity.y = smoll_jump_power
	retract_timer = retract_duration

	player.hitbox.disable()

func exit() -> void:
	player.hitbox.disable()
	is_dashing_forward = false

func physics_update(delta: float) -> void:
	if retract_timer > 0.0:
		player.velocity.x = lunge_speed * -lunge_direction
	else:
		if not is_dashing_forward:
			is_dashing_forward = true
			player.sprite.play("f_dash")
			player.sprite.frame = 1
			player.hitbox.enable()

		player.velocity.x = lunge_speed * lunge_direction * 3.0
	player.apply_gravity(delta)
	player.move_and_slide()

	timer += delta
	retract_timer -= delta

	var hit_wall = false
	if not is_dashing_forward:
		return
	
	for i in range(player.get_slide_collision_count()):
		var collision = player.get_slide_collision(i)
		var collision_point = collision.get_position()
		var collision_direction = sign(collision_point.x - player.global_position.x)
		if abs(collision.get_normal().x) > 0.5 and collision_direction != player.facing_direction and is_dashing_forward:
			hit_wall = true
			break

	if timer >= lunge_duration or hit_wall:
		state_machine.transition_to("RecoveryState")
