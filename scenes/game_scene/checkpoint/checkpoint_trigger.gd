extends Area2D

@export var checkpoint_count: int = 0

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        print("diiih")
        GameStates.set_checkpoint(global_position, checkpoint_count)