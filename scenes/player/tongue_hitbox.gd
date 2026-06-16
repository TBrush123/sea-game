class_name TongueHitbox
extends Area2D

var damage: int = 1
var can_break_walls: bool = false
@export var knockback_force = 100.0

func _ready() -> void:
    monitoring = false
    body_entered.connect(_on_body_entered)
    area_entered.connect(_on_area_entered)

func _on_body_entered(body: Node2D) -> void:
    if body.has_method("take_hit") and body.is_in_group("enemy"):
        var direction = sign(body.global_position.x - global_position.x)
        body.take_hit(damage, Vector2(direction, 0) * knockback_force)
        HitStop.freeze(0.06 * damage, 0.3 / damage)
        get_viewport().get_camera_2d().shake(16.0)

func _on_area_entered(area: Area2D) -> void:
    if can_break_walls and area.has_method("break_wall"):
        area.break_wall()

func enable() -> void:
    print("hitbox enabled, monitoring: ", monitoring)
    monitoring = true

func disable() -> void:
    monitoring = false
