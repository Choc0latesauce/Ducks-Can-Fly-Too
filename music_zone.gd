extends Area2D

@export var area_music: AudioStream
@export var fade_duration: float = 1.0

@onready var music_player: AudioStreamPlayer2D = %MusicPlayer

var previous_music: AudioStream = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and area_music:
		previous_music = music_player.stream
		_change_music(area_music)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player" and previous_music:
		_change_music(previous_music)

func _change_music(new_stream: AudioStream) -> void:
	if music_player.stream == new_stream:
		return
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", -80.0, fade_duration / 2.0)
	tween.tween_callback(func(): 
		music_player.stream = new_stream
		music_player.play())

	tween.tween_property(music_player, "volume_db", 0.0, fade_duration / 2.0)
