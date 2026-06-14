class_name State
extends Node

var player: CharacterBody2D
var state_machine: StateMachine

func enter() -> void:
    pass

func exit() -> void:
    pass

func physics_update(delta: float) -> void:
    pass

func handle_input(event: InputEvent) -> void:
    pass

func enable_hitbox_delayed(hitbox: Node, delay: float) -> void:
    var state_ref = self
    await get_tree().create_timer(delay).timeout
    if is_instance_valid(hitbox) and state_machine.current_state == state_ref:
        hitbox.enable()