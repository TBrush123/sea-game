extends Area2D

@export var boss: SuperCoolBoss
@export var timeline: DialogicTimeline
@export var boss_camera: Camera2D
@export var boss_music: AudioStream
@export var music_fade_duration: float = 1.5
@export var current_camera: Camera2D

var triggered: bool = false
var player_ref: Node = null
var audio_stream: AudioStreamPlayer

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    audio_stream = get_tree().get_first_node_in_group("audio")

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player") and not triggered:
        triggered = true
        player_ref = body

        current_camera.enabled = false
        boss_camera.enabled = true

        player_ref.set_movement_locked(true)
        player_ref.state_machine.transition_to("IdleState")

        Dialogic.timeline_ended.connect(_on_dialogue_ended, CONNECT_ONE_SHOT)
        Dialogic.start(timeline)
    
func _on_dialogue_ended() -> void:
    if is_instance_valid(player_ref):
        player_ref.set_movement_locked(false)

    var dormant = boss.state_machine.states.get("DormantState")
    if dormant:
        dormant.activate()

    play_boss_music()
    

func play_boss_music(duration: float = 1.0) -> void:
    var fade_out = create_tween() 
    fade_out.tween_property(audio_stream, "volume_db", -80.0, duration)
    await fade_out.finished

    audio_stream.stop()
    audio_stream.stream = boss_music
    audio_stream.volume_db = -80.0
    audio_stream.play()

    var fade_in = create_tween()
    fade_in.tween_property(audio_stream, "volume_db", -40.0, duration * 2) \
        .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


    