extends Area2D

@export var mutation: MutationManager.mutation_type = MutationManager.mutation_type.DASH
@export var timeline: DialogicTimeline

func _ready() -> void:
    body_entered.connect(_body_entered)

func _body_entered(body: Node2D) -> void:
    
    if body.is_in_group("player"):
        MutationManager.add_mutation(mutation)
        Dialogic.start(timeline)
        queue_free()