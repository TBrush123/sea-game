class_name EnemyBase
extends CharacterBody2D

@export var max_health: int = 3
@export var move_speed: float = 40.0
@export var attack_damage: int = 1
@export var gravity: float = 900
@onready var edge_detector: RayCast2D = $EdgeDetector
@export var raycast: RayCast2D

var health: int
var facing_direction: int = -1

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Hitbox = $Hitbox
@onready var state_machine: Node = $StateMachine
@onready var detection_area: Area2D = $DetectionArea
@onready var alert_sprite: Sprite2D = $AlertSprite
@onready var alert_sfx: AudioStreamPlayer2D = $AlertSFX
@onready var death_particles: GPUParticles2D = $DeathParticles
@onready var flash_animation: AnimationPlayer = $AnimatedSprite2D/FlashAnimation

func _ready() -> void:
	health = max_health

func apply_gravity(delta: float, gravity_scale: float = 1.0) -> void:
	velocity.y += gravity * delta * gravity_scale

func take_hit(damage: int, knockback: Vector2) -> void:
	health -= damage
	velocity += knockback

	modulate = Color.RED
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.15)

	var player = get_tree().get_first_node_in_group("player")
	if player.facing_direction == facing_direction:
		update_facing(facing_direction * -1)

	if health > 0:
		get_viewport().get_camera_2d().shake(4.0)
		HitStop.freeze()
	else:
		get_viewport().get_camera_2d().shake(8.0)
		HitStop.freeze(0.12, 0.02)
 
	if health <= 0:
		die()
	
	flash_animation.play("hit_animation_enemy")

func die() -> void:
	death_particles.global_position = global_position
	death_particles.emitting = true
	sprite.hide()
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	await get_tree().create_timer(0.5).timeout
	queue_free()

func update_facing(direction: float) -> void:
	if direction != 0 and direction != facing_direction:
		facing_direction = sign(direction)
		sprite.flip_h = facing_direction > 0
		sprite.position.x *= -1
		hitbox.position.x *= -1
		detection_area.scale.x *= -1
		if raycast:
			raycast.target_position.x *= -1
		if edge_detector:
			edge_detector.target_position.x *= -1
			edge_detector.position.x *= -1
	
func stun(duration: float) -> void:
	if state_machine.current_state.name != "StunState":
		state_machine.transition_to("StunState")
		var timer = get_tree().create_timer(duration)
		timer.timeout.connect(_on_stun_end)
	
func _on_stun_end() -> void:
	if state_machine.current_state.name == "StunState":
		state_machine.transition_to("PatrolState")
