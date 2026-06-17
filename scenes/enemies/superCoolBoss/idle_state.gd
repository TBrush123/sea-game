extends State

@export var idle_duration: float = 5.0

var timer: float = 0.0
var direction: int = -1

func enter() -> void:
	#player.sprite.play("idle")
	timer = 0.0

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move_and_slide()
	timer += delta

	if timer < idle_duration:
		return
	
	var target = _get_player()
	if not target:
		return
	
	direction = sign(player.global_position.x - target.global_position.x)

	player.velocity.x = player.move_speed * direction
	
	var dist = abs(target.global_position.x - player.global_position.x)

	if player.phase == 1:
		if dist < 1000:
			_telegraph("SlamState")
		else:
			_telegraph("StompState")
	else:
		var roll = randi() % 2
		match roll:
			0: _telegraph("SlamState")
			1: _telegraph("StompState")

func _telegraph(next_state: String) -> void:
	state_machine.states["TelegraphState"].next_state = next_state
	state_machine.transition_to("TelegraphState")

func _get_player() -> Node2D:
	return get_tree().get_first_node_in_group("player")
