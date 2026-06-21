extends State

@export var idle_duration: float = 1.5

var timer: float = 0.0
var direction: int = -1

func enter() -> void:
	player.sprite.play("idle")
	player.velocity.x = 0
	timer = 0.0

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move_and_slide()
	timer += delta

	if timer < idle_duration * player.get_attack_speed_multiplier():
		return
	
	var target = _get_player()
	if not target:
		return
	
	direction = sign(player.global_position.x - target.global_position.x)
	player.update_facing(direction)

	player.velocity.x = player.move_speed * direction
	
	var dist = abs(target.global_position.x - player.global_position.x)

	if dist > 3000:
		state_machine.transition_to("WalkState")
		return
	
	elif dist < 1000:
		var rand_move = randi_range(1, 2)
		match rand_move:
			1:
				_telegraph("InkAttackState")
			2:
				_telegraph("StompState")
	else:
		_telegraph("SlamState")

func _telegraph(next_state: String) -> void:
	state_machine.states["TelegraphState"].next_state = next_state
	state_machine.transition_to("TelegraphState")

func _get_player() -> Node2D:
	return get_tree().get_first_node_in_group("player")
