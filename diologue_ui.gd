extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var text_label: RichTextLabel = $Panel/RichTextLabel

var is_active: bool = false
var dialogue_queue: Array[String] = []
var current_line: int = 0
var can_close: bool = false
var text_tween: Tween

@export var character_speed: float = 0.03

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func show_dialogue(lines: Array[String]) -> void:
	panel.size = Vector2(800, 150)
	var screen_size = get_viewport().get_visible_rect().size
	panel.position = Vector2((screen_size.x - 800) / 2, screen_size.y - 180)
	dialogue_queue = lines
	current_line = 0
	is_active = true
	visible = true
	panel.visible = true
	text_label.visible = true
	_display_current_line()
	get_tree().paused = true
	can_close = false
	await get_tree().create_timer(0.2, true, false, true).timeout
	can_close = true

func _input(event: InputEvent) -> void:
	if not is_active or not can_close:
		return
	if event.is_action_pressed("interact"):
		if text_tween and text_tween.is_running():
			text_tween.kill()
			text_label.visible_characters = -1
		else:
			current_line += 1
			if current_line < dialogue_queue.size():
				_display_current_line()
			else:
				_close_dialogue()
			get_viewport().set_input_as_handled()

func _display_current_line() -> void:
	text_label.text = dialogue_queue[current_line]
	text_label.visible_characters = 0
	if text_tween:
		text_tween.kill()
	var total_characters = text_label.get_total_character_count()
	var duration = total_characters * character_speed
	text_tween = create_tween()
	text_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	text_tween.tween_property(text_label, "visible_characters", total_characters, duration)

func _close_dialogue() -> void:
	if text_tween:
		text_tween.kill()
	is_active = false
	visible = false
	get_tree().paused = false
