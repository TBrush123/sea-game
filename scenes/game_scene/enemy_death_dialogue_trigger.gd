extends Node

signal dialogue_completed

@export var target_enemy: Node2D
@export var timeline: DialogicTimeline
@export var ability_acquired: MutationManager.mutation_type

var player_ref: Node = null

func _ready() -> void:
    if target_enemy:
        target_enemy.died.connect(_on_enemy_died)
    player_ref = get_tree().get_first_node_in_group("player")

func _on_enemy_died() -> void:
    await get_tree().create_timer(1.0).timeout
    if player_ref and is_instance_valid(player_ref):
        player_ref.set_movement_locked(true)
        player_ref.state_machine.transition_to("IdleState")
    
    for enemy in get_tree().get_nodes_in_group("enemy"):
        enemy.set_physics_process(false)
        enemy.set_process(false)

    Dialogic.timeline_ended.connect(_on_timeline_ended, CONNECT_ONE_SHOT)
    Dialogic.start(timeline)

func _on_timeline_ended() -> void:
    if player_ref and is_instance_valid(player_ref):
        player_ref.set_movement_locked(false)

    for enemy in get_tree().get_nodes_in_group("enemy"):
        enemy.set_physics_process(true)
        enemy.set_process(true)

    
    if ability_acquired:
        MutationManager.add_mutation(ability_acquired)

    dialogue_completed.emit()

    queue_free()