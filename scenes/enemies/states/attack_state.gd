extends State

var attack_done: bool = false

func enter() -> void:
	player.sprite.play("attack")
	player.velocity.x = 0
	attack_done = false
	player.hitbox.enable()
	player.sprite.animation_finished.connect(_on_anim_finished)

func exit() -> void:
	player.hitbox.disable()
	if player.sprite.animation_finished.is_connected(_on_anim_finished):
		player.sprite.animation_finished.disconnect(_on_anim_finished)

func physics_update(delta: float) -> void:
	player.move_and_slide()
	if attack_done:
		state_machine.transition_to("ChaseState")
		return

func _on_anim_finished() -> void:
	attack_done = true
	
