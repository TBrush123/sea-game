class_name Player
extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var basic_attack_hitbox: Area2D = $BasicAttackHitbox
@onready var hurt_sfx: AudioStreamPlayer2D = $HurtSFX
@onready var dash_hitbox: Area2D = $DashHitbox
@onready var dash_particles: GPUParticles2D = $DashParticles
@onready var tongue_sprite: Sprite2D = $TummyMask/TongueSprite
@onready var tongue_hitbox: Area2D = $TongueHitbox
@onready var tummy_mask: Sprite2D = $TummyMask
@onready var flash_animation: AnimationPlayer = $AnimatedSprite2D/FlashAnimation

@export var speed: float = 200.0
@export var jump_velocity: float = -670.0
@export var gravity: float = 900.0
@export var coyote_time: float = 0.12
@export var max_health: int = 5
@export var dash_speed: float = 1000.0
@export var dash_duration: float = 0.18
@export var dash_cooldown: float = 0.4
@export var tongue_min_damage: int = 1
@export var tongue_max_damage: int = 4
@export var tongue_max_charge_time: float = 1.0
@export var tongue_speed: float = 250.0
@export var invincible_time: float = 5.0

var can_dash: bool = true
var camera: Camera2D
var health: int
var coyote_timer: float = 0.0
var facing_direction: int = 1
var invincibility_timer: float = 0.0
var is_invincible: bool = false
var jumped: bool = false

func _ready() -> void:
	health = max_health
	camera = $Camera2D

func _physics_process(delta: float) -> void:
	update_timers(delta)

func can_jump() -> bool:
	return coyote_timer > 0.0

func update_timers(delta: float) -> void:
	if is_on_floor():
		if not jumped:
			coyote_timer = coyote_time
	else: 
		coyote_timer -= delta
		jumped = false
	if invincibility_timer > 0:
		invincibility_timer -= delta
	else:
		is_invincible = false
		flash_animation.stop()

func apply_gravity(delta: float, gravity_scale: float = 1.0) -> void:
	velocity.y += gravity * delta * gravity_scale

func update_facing(direction: float) -> void:
	if direction != 0 and direction != facing_direction:
		facing_direction = sign(direction)
		sprite.flip_h = facing_direction < 0
		basic_attack_hitbox.position.x *= -1
		tummy_mask.position.x *= -1
		tongue_sprite.position.x *= -1
		tongue_sprite.flip_h = facing_direction < 0

	
func set_movement_locked(locked: bool) -> void:
	state_machine.set_physics_process(locked == false)
	state_machine.set_process_unhandled_input(locked == false)
	if locked:
		velocity.x = 0
		
func take_hit(damage: int, knockback: Vector2) -> void:
	if is_invincible:
		return
	
	health -= damage
	velocity += knockback
	print("knockback:", knockback, " velocity:", velocity)
	state_machine.transition_to("HurtState")
	get_viewport().get_camera_2d().shake(8.0)

		
		
	is_invincible = true

	if health <= 0:
		die()
	else: 
		invincibility_timer = invincible_time
	
	flash_animation.play("hit_animation")

func die() -> void:
	is_invincible = true
	velocity = Vector2.ZERO
	set_movement_locked(true)
	sprite.modulate = Color.WHITE

	await get_tree().create_timer(0.6).timeout

	GameStates.respawn_player(self)

	set_movement_locked(false)
	is_invincible = false
	state_machine.transition_to("IdleState")
