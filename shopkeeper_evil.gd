extends Area2D

@export var dialogue_lines: Array[String] = [
	" HAHA you fell for my evil trap!",
	" Now you're stuck in my evil dungeon!",
	" No more flying for you little duckie :(",
	" Don't even bother trying to escape, you won't survive..."
]

@onready var interact_prompt: Label = $InteractPrompt
@onready var dialogue_ui = %DialogueUI

var is_player_nearby: bool = false
var player_ref: CharacterBody2D = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	interact_prompt.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if is_player_nearby and event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		_trigger_shop_interaction()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_player_nearby = true
		player_ref = body as CharacterBody2D
		interact_prompt.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_player_nearby = false
		player_ref = null
		interact_prompt.visible = false

func _trigger_shop_interaction() -> void:
	if dialogue_ui:
		dialogue_ui.show_dialogue(dialogue_lines)
	else:
		print("ERROR: dialogue_ui is missing!")
