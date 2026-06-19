extends State

@export var telegraph_duration: float = 0.5

var timer: float = 0.0
var target: Node2D = null
var lunge_direction: int = 1

func enter() -> void:
	player.sprite.play("f_idle")
	player.sprite.stop()
	player.velocity.x = 0
	timer = 0.0

	for body in player.detection_area.get_overlapping_bodies():
		if body.is_in_group("player"):
			target = body
			break
	if target == null:
		state_machine.transition_to("PatrolState")
		return
	lunge_direction = sign(target.global_position.x - player.global_position.x)
	player.update_facing(lunge_direction)
	
	player.modulate = Color(1.5, 1.5, 1.0)

func exit() -> void:
	player.modulate = Color.WHITE

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move_and_slide()

	if timer < telegraph_duration:
		timer += delta
	else:
		state_machine.transition_to("LungeState")
