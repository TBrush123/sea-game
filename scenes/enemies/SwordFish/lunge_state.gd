extends State

@export var lunge_speed: float = 1500.0
@export var lunge_duration: float = 1.0
@export var retract_duration: float = 0.2


var timer: float = 0.0
var lunge_direction: int = 1
var retract_timer: float = 0.0

func enter() -> void:
	#player.sprite.play("lunge")
	timer = 0.0
	
	lunge_direction = player.facing_direction
	player.velocity.x = lunge_speed * lunge_direction
	retract_timer = retract_duration

	player.hitbox.enable()

func exit() -> void:
	player.hitbox.disable()

func physics_update(delta: float) -> void:
	if retract_timer > 0.0:
		player.velocity.x = lunge_speed * -lunge_direction
	else:
		player.velocity.x = lunge_speed * lunge_direction * 1.5
	player.apply_gravity(delta)
	player.move_and_slide()

	timer += delta
	retract_timer -= delta

	var hit_wall = false
	if retract_timer > 0.0:
		return
	for i in range(player.get_slide_collision_count()):
		var collision = player.get_slide_collision(i)
		if abs(collision.get_normal().x) > 0.5:
			hit_wall = true
			break

	if timer >= lunge_duration or hit_wall:
		state_machine.transition_to("PatrolState")
