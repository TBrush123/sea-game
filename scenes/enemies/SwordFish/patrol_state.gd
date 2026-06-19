extends State

@export var patrol_distance: float = 200.0
@export var lunge_cooldown: float = 5.0
@export var sight_linger_duration: float = 1.5
@export var turn_cooldown: float = 0.3

var start_x: float
var direction: int = -1
var cooldown_timer: float = 0.0
var sight_linger_timer: float = 0.0
var last_seen_player: Node2D = null
var turn_cooldown_timer: float = 0.0

func enter() -> void:
	player.sprite.play("f_walk")
	start_x = player.global_position.x
	cooldown_timer = lunge_cooldown
	sight_linger_timer = sight_linger_duration
	turn_cooldown_timer = turn_cooldown

func physics_update(delta: float) -> void:
	player.velocity.x = direction * player.move_speed
	player.update_facing(direction)
	player.move_and_slide()
	player.apply_gravity(delta)

	turn_cooldown_timer -= delta

	if turn_cooldown_timer <= 0.0:
		var should_turn = false
		for i in range(player.get_slide_collision_count()):
			var collision = player.get_slide_collision(i)
			if abs(collision.get_normal().x) > 0.5:
				should_turn = true
				break
		if player.is_on_floor() and player.edge_detector != null and not player.edge_detector.is_colliding():
			should_turn = true
	

		if abs(player.global_position.x - start_x) > patrol_distance:
			should_turn = true
		
		if should_turn:
			direction *= -1
			turn_cooldown_timer = turn_cooldown


	cooldown_timer -= delta

	var can_see_player = false
	if player.raycast.is_colliding():
		var hit = player.raycast.get_collider()
		if hit != null and hit.is_in_group("player"):
			can_see_player = true
			last_seen_player = hit
			sight_linger_timer = 0.0

	if not can_see_player and sight_linger_timer > 0.0:
		sight_linger_timer -= 0
		can_see_player = true
	
	if can_see_player and last_seen_player != null and cooldown_timer <= 0.0:
		state_machine.transition_to("TelegraphState")
		return

	if sight_linger_timer <= 0.0:
		last_seen_player = null
