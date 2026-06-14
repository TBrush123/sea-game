extends State

@export var chase_speed: float = 70.0
@export var attack_range: float = 20.0
var target: Node2D = null

func enter() -> void:
	#player.sprite.play("walk")
	var tween = create_tween()
	tween.tween_property(player, "modulate", Color.PURPLE, 0.1)
	for body in player.detection_area.get_overlapping_bodies():
		if body.is_in_group("player"):
			target = body
			break

func physics_update(delta: float) -> void:
	if target == null or not is_instance_valid(target):
		state_machine.transition_to("PatrolState")
		return
	
	var distance = player.global_position.distance_to(target.global_position)
	var direction = sign(target.global_position.x - player.global_position.x)

	if distance <= attack_range:
		print("I'm ATTACKING!!!!")
		state_machine.transition_to("AttackState")
		return

	player.velocity.x = direction * chase_speed
	player.apply_gravity(delta)
	player.update_facing(direction)
	player.move_and_slide()
