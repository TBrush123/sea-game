extends HBoxContainer

@export var heart_texture: Texture2D
@export var heart_size: Vector2 = Vector2(32, 32)

func _ready() -> void:
    var player = get_tree().get_first_node_in_group("player")
    if player:
        _setup_hearts(player.health)
        player.health_changed.connect(_on_health_changed)

func _setup_hearts(health: int) -> void:
    for child in get_children():
        child.queue_free()

    for i in range(health):
        var heart = TextureRect.new()
        heart.texture = heart_texture
        heart.custom_minimum_size = heart_size
        heart.size = heart_size
        heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
        heart.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
        heart.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
        heart.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
        add_child(heart)

func _on_health_changed(new_health: int) -> void:
    _setup_hearts(new_health)