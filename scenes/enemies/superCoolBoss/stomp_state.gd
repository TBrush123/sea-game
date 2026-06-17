extends State

@export var stomp_recovery: float = 0.5
@export var shockwave_scene: PackedScene

var timer: float = 0.0

func enter() -> void:
	#player.sprite.play("stomp")
	player.velocity.x = 0
	timer = 0.0
	_spawn_shockwaves()

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move_and_slide()
	timer += delta
	if timer >= stomp_recovery:
		state_machine.transition_to("IdleState")
	
func _spawn_shockwaves() -> void:
	get_viewport().get_camera_2d().shake(30.0)
	HitStop.freeze(0.08, 0.05)
	for dir in [-1, 1]:
		var shockwave = shockwave_scene.instantiate()
		shockwave.global_position = player.shockwave_marker.global_position
		shockwave.direction = dir
		get_tree().current_scene.add_child(shockwave)
