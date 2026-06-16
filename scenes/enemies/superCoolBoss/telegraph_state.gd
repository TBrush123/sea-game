extends State

@export var telegraph_duration: float = 0.5
@export var next_state: String = "SlamState"

var timer: float = 0.0
var telegraph_tween: Tween

func enter() -> void:
	#player.sprite.play("telegraph")
	player.velocity.x = 0
	timer = 0.0

	var target = _get_player()
	if target:
		player.update_facing(sign(target.global_position.x - player.global_position.x))
	
	telegraph_tween = player.create_tween().set_loops()
	telegraph_tween.tween_property(player, "position:x", player.position.x + 3, 0.05)
	telegraph_tween.tween_property(player, "position:x", player.position.x - 3, 0.05)
	telegraph_tween.play()

func exit() -> void:
	if telegraph_tween != null:
		telegraph_tween.kill()
		player.position.x = round(player.position.x)

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move_and_slide()

	if timer < telegraph_duration:
		timer += delta
	else:
		state_machine.transition_to("LungeState")
