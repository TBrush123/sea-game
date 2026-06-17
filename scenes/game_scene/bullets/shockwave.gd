extends Area2D

@export var speed: float = 1800.0
@export var damage: int = 1

var direction: int = 1

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
    position.x += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player") and body.has_method("take_hit"):
        body.take_hit(damage, Vector2(direction, -0.3).normalized() * 200)
        queue_free()
