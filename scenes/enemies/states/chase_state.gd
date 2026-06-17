extends State

@export var attack_range: float = 500.0
@export var attack_time: float = 3.0

var attack_timer: float = 0.0
var target: Node2D = null

func enter() -> void:
	player.sprite.play("walk")
	player.sprite.speed_scale = 1.5
	attack_timer = attack_time
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

	player.velocity.x = direction * player.move_speed * 4

	if distance <= attack_range and attack_timer <= 0:
		print("I'm ATTACKING!!!!")
		state_machine.transition_to("AttackState")
		return
	elif distance <= attack_range:
		player.velocity.x = 0
		player.sprite.stop()
	else:
		player.sprite.play("walk")

	attack_timer -= delta
	player.apply_gravity(delta)
	player.update_facing(direction)
	player.move_and_slide()
