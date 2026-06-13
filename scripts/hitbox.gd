class_name Hitbox
extends Area2D

@export var damage: int = 1
@export var knockback_force: float = 200.0
@export var damage_source: CharacterBody2D

func _ready() -> void:
    monitoring = false
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
    if body.has_method("take_hit") and body != damage_source:
        var direction = Vector2(1, 0) if global_position.x <= body.global_position.x else Vector2(-1, 0)
        body.take_hit(damage, direction * knockback_force)

func enable() -> void:
    monitoring = true

func disable() -> void:
    monitoring = false