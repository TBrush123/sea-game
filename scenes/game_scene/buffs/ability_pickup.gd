extends Area2D

signal dialogue_completed

@export var mutation: MutationManager.mutation_type = MutationManager.mutation_type.DASH
@export var timeline: DialogicTimeline

var player_ref: Node = null

func _ready() -> void:
	body_entered.connect(_body_entered)
	var dialogic_node = get_node_or_null("/root/Dialogic")
	if dialogic_node:
		dialogic_node.process_mode = Node.PROCESS_MODE_ALWAYS

func _body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_ref = body
		MutationManager.add_mutation(mutation)

		player_ref.set_movement_locked(true)
		player_ref.state_machine.transition_to("IdleState")

		Dialogic.start(timeline)
		Dialogic.timeline_ended.connect(_on_timeline_ended, CONNECT_ONE_SHOT)
	
func _on_timeline_ended() -> void:
	if is_instance_valid(player_ref):
		player_ref.set_movement_locked(false)
	dialogue_completed.emit()
	queue_free()
