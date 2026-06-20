extends Node

var checkpoint_position: Vector2 = Vector2.ZERO
var checkpoint_count: int = -1

func set_checkpoint(pos: Vector2, count: int) -> void:
    if checkpoint_count < count:
        checkpoint_position = pos
        checkpoint_count = count

func respawn_player(player: Node2D) -> void:
    player.global_position = checkpoint_position
    player.health = player.max_health
    player.velocity = Vector2.ZERO

