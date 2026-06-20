extends State

@export var prefered_distance: float = 2400.0
@export var too_close_distance: float = 800.0

var target: Node2D = null

func enter() -> void:
    player.sprite.play("idle")
    player.sprite.speed_scale = 2.0
    target = player.get_player()

func exit() -> void:
    player.sprite.speed_scale = 1.0

func physics_update(delta: float) -> void:
    player.apply_gravity(delta)

    target = player.get_player()
    if not target or not is_instance_valid(target):
        state_machine.transition_to("IdleState")
        return
    
    var dist = player.global_position.distance_to(target.global_position)
    var direction = sign(target.global_position.x - player.global_position.x)

    if dist <= too_close_distance:
        player.velocity.x = -direction * player.move_speed * 0.5 * player.get_speed_multiplier()
        player.update_facing(direction)
    
    elif dist <= prefered_distance:
        player.velocity.x = move_toward(player.velocity.x, 0, 400 * delta)
        player.update_facing(direction)
        state_machine.transition_to("IdleState")
        return
    
    else:
        player.velocity.x = direction * player.move_speed * player.get_speed_multiplier()
        player.update_facing(direction)
    
    for i in player.get_slide_collision_count():
        if abs(player.get_slide_collision(i).get_normal().x) > 0.5:
            player.velocity.x = 0
            break

    player.move_and_slide()