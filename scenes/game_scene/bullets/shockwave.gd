extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast: RayCast2D = $RayCast2D
@export var speed: float = 1800.0
@export var damage: int = 1

var direction: int = 1
var shrink: bool = false

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    sprite.play("hit")
    sprite.pause()
    raycast.target_position.x = abs(raycast.target_position.x) * direction


func _physics_process(delta: float) -> void:
    if raycast.is_colliding():
        var collision = raycast.get_collider()
        if not collision.is_in_group("player") and not shrink:
            shrink = true
            sprite.play()
    position.x += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player") and body.has_method("take_hit"):
        if not body.is_invincible:
            body.take_hit(damage, Vector2(direction, -0.3).normalized() * 200)
        queue_free()
