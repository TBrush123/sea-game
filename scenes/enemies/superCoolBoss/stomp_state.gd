extends State

@export var shockwave_scene: PackedScene

var timer: float = 0.0
var shot_shockwaves: bool = false

func enter() -> void:
	player.sprite.play("attack1")
	shot_shockwaves = false
	player.sprite.frame_changed.connect(_check_needed_frame)
	player.sprite.animation_finished.connect(_finish_attack)
	player.velocity.x = 0
	timer = 0.0

func _check_needed_frame() -> void:
	if player.sprite.get_frame() == 7 and not shot_shockwaves:
		shot_shockwaves = true
		_spawn_shockwaves()


func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move_and_slide()
	
func _finish_attack() -> void:
	player.state_machine.transition_to("WalkState")

func _spawn_shockwaves() -> void:
	get_viewport().get_camera_2d().shake(30.0)
	HitStop.freeze(0.08, 0.05)

	for dir in [-1, 1]:
		var shockwave = shockwave_scene.instantiate()
		shockwave.global_position = player.shockwave_marker.global_position
		shockwave.direction = dir
		shockwave.speed *= player.get_speed_multiplier()
		get_tree().current_scene.add_child(shockwave)
