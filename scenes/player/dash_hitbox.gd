class_name DashHitbox
extends Area2D

@export var stun_duration: float = 1.0
@export var knockback_force: float = 100.0

func _ready() -> void:
    monitoring = false
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:

    if body.has_method("stun"):
        body.stun(stun_duration)

    if body.has_method("take_hit"):
        var direction = sign(body.global_position.x - global_position.x)
        body.take_hit(0, Vector2(direction, 0) * knockback_force)

func enable() -> void:
    monitoring = true

func disable() -> void:
    monitoring = false   