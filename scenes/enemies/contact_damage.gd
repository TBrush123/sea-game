class_name ContactDamage
extends Area2D

@export var damage: int = 1
@export var knockback_force: float = 150.0
@export var damage_cooldown: float = 0.5

var recently_hit: Dictionary = {}

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player") and body.has_method("take_hit"):
        if not body.is_invincible:
            var direction = -1 if body.global_position.x <= global_position.x else 1
            body.take_hit(damage, Vector2(direction, 0) * knockback_force)

    
