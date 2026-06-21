extends State

@export var windup_delay: float = 0.2
@export var anticipation_time: float = 0.5
@export var attack_duration: float = 1.25

var attack_done: bool = false
var attack_timer: float = 0.0
var anticipation_timer: float = 0.0
var hitbox_enabled: bool = false
var attacking: bool = false

func enter() -> void:
	player.sprite.play("anticipate")
	player.sprite.speed_scale = 1.0
	anticipation_timer = anticipation_time
	attack_timer = 0.0
	hitbox_enabled = false
	attacking = false
	player.velocity.x = 0
	attack_done = false
	player.sprite.animation_finished.connect(_on_anim_finished)



func exit() -> void:
	player.hitbox.disable()

func physics_update(delta: float) -> void:
	player.move_and_slide()
	player.apply_gravity(delta)

	if anticipation_timer > 0.0:
		anticipation_timer -= delta
		return

	if not hitbox_enabled:
		hitbox_enabled = true
		attacking = true
		player.sprite.play("attack")
		enable_hitbox_delayed(player.hitbox, windup_delay)
	
	if attacking:
		attack_timer += delta
		if attack_timer >= attack_duration:
			state_machine.transition_to("ChaseState") 

func _on_anim_finished() -> void:
	attack_done = true
	
