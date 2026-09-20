extends CharacterBody2D


const SPEED = 200.0
const MAX_FALL_SPEED = 600.0
const FLAP_FORCE = -380.0

const MAX_ENERGY = 100.0
const ENERGY_PER_FLAP = 15.0	

const BASE_CAMERA_OFFSET_Y = -40.0
const COYOTE_TIME = 0.15

var energy = MAX_ENERGY
var coyote_timer: float = 0.0

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var camera: Camera2D = $Camera2D
@onready var energy_bar: TextureProgressBar = $"../HUD/TextureProgressBar"

func _physics_process(delta: float) -> void:
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta
		velocity += get_gravity() * delta
		velocity.y = min(velocity.y, MAX_FALL_SPEED)
	if Input.is_action_just_pressed("jump"):
		if coyote_timer > 0.0:
			coyote_timer = 0.0
			velocity.y = FLAP_FORCE
			_trigger_camera_jump_feedback()
		elif energy >= ENERGY_PER_FLAP:
			velocity.y = FLAP_FORCE
			energy -= ENERGY_PER_FLAP

	var direction := Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	_update_rotation(delta)
	move_and_slide()
	_update_animations()
	_update_camera_look_ahead(delta)
	_update_energy_ui()

func _update_rotation(delta: float) -> void:
	if not is_on_floor():
		var target_angle = remap(velocity.y, FLAP_FORCE, MAX_FALL_SPEED, -0.5, 1.2)
		sprite.rotation = lerp_angle(sprite.rotation, target_angle, 10.0 * delta)
	else:
		sprite.rotation = lerp_angle(sprite.rotation, 0.0, 15.0 * delta)

func _update_animations() -> void:
	if is_on_floor():
		if velocity.x !=0:
			sprite.play("walk")
		else:
			sprite.play("idle")
	else:
		if velocity.y < 0:
			sprite.play("fly")
		else:
			sprite.play("fall")

func _update_camera_look_ahead(delta: float) -> void:
	var target_offset_y = BASE_CAMERA_OFFSET_Y
	if not is_on_floor():
		if velocity.y < 0:
			target_offset_y = BASE_CAMERA_OFFSET_Y + 30.0
		else:
			target_offset_y = BASE_CAMERA_OFFSET_Y + 20.0
	camera.offset.y = lerp(camera.offset.y, target_offset_y, 4.0 * delta)

func _trigger_camera_jump_feedback() -> void:
	var tween = create_tween()
	tween.tween_property(camera, "offset:y", camera.offset.y + 12.0, 0.05)
	tween.tween_property(camera, "offset:y", camera.offset.y, 0.1)

func _update_energy_ui() -> void:
	if energy_bar:
		energy_bar.value = energy
		var global_player_pos = global_position
		var screen_pos = get_canvas_transform() * global_player_pos
		var offset_x = 50.0 if sprite.flip_h else -100.0
		var target_pos = screen_pos + Vector2(offset_x, 10)
		energy_bar.position = energy_bar.position.lerp(target_pos, 15.0 * get_physics_process_delta_time())

func restore_energy(amount: float) -> void:
	energy = min(energy + amount, MAX_ENERGY)
	_update_energy_ui()

func apply_wind(force: Vector2) -> void:
	velocity += force
