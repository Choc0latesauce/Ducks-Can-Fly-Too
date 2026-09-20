extends Area2D

@export var speed: float = 60.0
@export var patrol_distance: float = 100.0
@export var energy_reward: float = 50.0

var start_x: float = 0.0
var direction: int = 1

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	start_x = position.x
	body_entered.connect(_on_body_entered)
	
func _physics_process(delta: float) -> void:
	position.x += speed * direction * delta
	sprite.play("default")
	if abs(position.x - start_x) >= patrol_distance:
		direction *= -1
		if sprite:
			sprite.flip_h = direction < 0

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var is_falling = body.velocity.y > 0
		var is_above = body.global_position.y < global_position.y -10.0
		if is_falling and is_above:
			body.velocity.y = -300.0
			if body.has_method("restore_energy"):
				body.restore_energy(energy_reward)
			call_deferred("queue_free")
		else:
			get_tree().call_deferred("reload_current_scene")
