class_name SuperCoolBoss
extends CharacterBody2D

signal died

@export var max_health: int = 20
@export var move_speed: float = 40.0
@export var phase2_threshold: float = 0.5
@export var gravity: float = 900

var health: int
var phase: int = 1
var facing_direction: int = -1

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var slam_hitbox: Hitbox = $Hitbox
@onready var state_machine: Node = $StateMachine
@onready var weak_point_hurtbox: Area2D = $WeakPointHurtbox
@onready var armor_hurtbox: Area2D = $ArmorHurtbox
@onready var death_particles: GPUParticles2D = $DeathParticles
@onready var shockwave_marker: Marker2D = $ShockwaveMarker

func _ready() -> void:
	health = max_health
	weak_point_hurtbox.monitoring = false

func apply_gravity(delta: float, gravity_scale: float = 1.0) -> void:
	velocity.y += gravity * delta * gravity_scale

func _physics_process(delta: float) -> void:
	apply_gravity(delta)

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
		get_viewport().get_camera_2d().shake(20.0)
		HitStop.freeze(0.12, 0.02)
	if health <= 0:
		die()
		return
		
	if health <= int(max_health * phase2_threshold) and phase == 1:
		state_machine.transition_to("PhaseTransitionState")
		return
	
	 
	
	if phase == 2:
		state_machine.transition_to("HurtState")

func take_weak_point_hit(damage: int, knockback: Vector2) -> void:
	health -= damage
	HitStop.freeze(0.1, 0.05)
	get_viewport().get_camera_2d().shake(6.0)

	modulate = Color.RED
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)

	if health <= 0:
		die()
		return

func die() -> void:
	died.emit()
	if death_particles:
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
		sprite.flip_h = facing_direction < 0
		slam_hitbox.position *= -1
	
func stun(duration: float) -> void:
	if state_machine.current_state.name != "StunState":
		state_machine.transition_to("StunState")
		var timer = get_tree().create_timer(duration)
		timer.timeout.connect(_on_stun_end)
	
func _on_stun_end() -> void:
	if state_machine.current_state.name == "StunState":
		state_machine.transition_to("PatrolState")
