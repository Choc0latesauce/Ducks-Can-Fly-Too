extends Area2D

@export var energy_restore_amount: float = 50.0

var is_collected: bool = false
var start_y: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	start_y = position.y
	body_entered.connect(_on_body_entered)
	
func _process(delta: float) -> void:
	if not is_collected:
		position.y = start_y + sin(Time.get_ticks_msec() * 0.003) * 4.0

func _on_body_entered(body: Node2D) -> void:
	if is_collected:
		return
	if body.has_method("restore_energy"):
		is_collected = true
		$CollisionShape2D.set_deferred("disabled", true)
		body.restore_energy(energy_restore_amount)
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(sprite, "scale", scale * 1.5, 0.08)
		tween.tween_property(sprite, "modulate:a", 0.0, 0.08)
		tween.chain().tween_callback(queue_free)
