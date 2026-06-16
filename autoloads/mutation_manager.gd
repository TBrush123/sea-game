extends Node

signal added_mutation(mutation: mutation_type)

var current_mutations: Array[mutation_type] = [mutation_type.BASE, mutation_type.DASH, mutation_type.TONGUE]

enum mutation_type {
    BASE,
    DASH,
    TONGUE,
}

func has_mutation(mutation: mutation_type) -> bool:
    return mutation in current_mutations

func add_mutation(mutation: mutation_type) -> void:
    if mutation not in current_mutations:
        current_mutations.append(mutation)

func remove_mutation(mutation: mutation_type) -> void:
    if mutation in current_mutations:
        current_mutations.erase(mutation)

