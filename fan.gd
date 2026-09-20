extends Area2D

@export var wind_force: Vector2 = Vector2(0, -1800.0)

var players_in_wind: Array[Node2D] = []

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _physics_process(delta: float) -> void:
	for body in players_in_wind:
		if body.has_method("apply_wind"):
			body.apply_wind(wind_force * delta)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		players_in_wind.append(body)

func _on_body_exited(body: Node2D) -> void:
	if body in players_in_wind:
		players_in_wind.erase(body)
