extends State

@export var ink_duration: float = 1.6
@export var ink_obscure_duration: float = 3.0
@export var base_recovery: float = 1.4
@export var ink_shot_count: int = 4

var timer: float = 0.0
var hit_player: bool = false
var frame_tween: Tween = null
var shot_count: int = 0

func enter() -> void:
	player.sprite.play("attack2")
	player.sprite.pause()
	player.velocity.x = 0
	timer = 0.0
	hit_player = false
	frame_tween = null

	_enable_ink_delayed()

func exit() -> void:
	_disable_ink()
	if frame_tween:
		frame_tween.kill()
		frame_tween = null

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move_and_slide()
	timer += delta

	if timer >= base_recovery * player.get_attack_speed_multiplier():
		state_machine.transition_to("WalkState")
	
func _enable_ink_delayed() -> void:
	await get_tree().create_timer(0.15).timeout
	if not is_instance_valid(player):
		return
	
	var frame_count = player.sprite.sprite_frames.get_frame_count("attack2")
	var last_frame = frame_count - 1
	var second_last_frame = frame_count - 2

	player.sprite.pause()
	player.sprite.frame = second_last_frame
	shot_count = 0
	hit_player = false

	frame_tween = player.create_tween()

	for i in range(ink_shot_count):
		frame_tween.tween_callback(
			func():
				player.sprite.frame = second_last_frame
				_disable_ink()
				hit_player = false
		)
		frame_tween.tween_interval(0.15)

		frame_tween.tween_callback(func():
			player.sprite.frame = last_frame
			_activate_ink()
		)
		frame_tween.tween_interval(0.15)

		frame_tween.tween_callback(func():
			_disable_ink()
		)
		

func _activate_ink() -> void:

	for child in player.ink.get_children():
		if child is Area2D:
			if not child.body_entered.is_connected(_on_ink_hit):
				child.body_entered.connect(_on_ink_hit)
			child.visible = true
			var sprite = child.get_child(0)
			sprite.play("default")
			child.monitoring = true

func _disable_ink() -> void:
	for child in player.ink.get_children():
		if child is Area2D:
			child.visible = false
			if child.body_entered.is_connected(_on_ink_hit):
				child.body_entered.disconnect(_on_ink_hit)
			child.monitoring = false

func _on_ink_hit(body: Node2D) -> void:
	if body.is_in_group("player") and not hit_player:
		hit_player = true

		#_obscure_player_vision(body)
