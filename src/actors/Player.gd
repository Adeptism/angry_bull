extends Actor


# ==========	Exported variables	============================================================================
export var dash_multiplier: float = 2.5


# ==========	Private variables	============================================================================
var _dash_direction: Vector2 = Vector2.ZERO
var _is_dashing: bool = false
var _can_dash: bool = true
onready var _is_dashing_timer: Timer = find_node("dashTimer")
onready var _dash_cooldown_timer: Timer = find_node("dashCooldownTimer")


# ==========	Callback functions	============================================================================
func _on_dashTimer_timeout() -> void:
	_is_dashing = false

func _on_dashCooldownTimer_timeout() -> void:
	_can_dash = true


# ==========	User-defined functions	========================================================================
func process_input() -> void:
	# Acquire movement input
	_input = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	if _input: _input = _input.normalized()
	# Acquire dash input
	if Input.is_action_just_pressed("move_dash") and _can_dash:
		_is_dashing = true
		_can_dash = false
		_dash_direction = _input * dash_multiplier if _input else _direction * dash_multiplier
		_is_dashing_timer.start(0.2)
		_dash_cooldown_timer.start(1.0)
	# Set direction
	if _input.x: _direction = Vector2(1.0 if _input.x >= 0.0 else -1.0, 0.0)

func calculate_velocity() -> void:
	if _is_dashing: handle_dash()
	else: _velocity = _input * move_speed

func set_animation() -> void:
	# Apply animation
	if _velocity and not _is_dashing: _state_machine.travel("movement")
	elif _is_dashing: _state_machine.travel("dash")
	else: _state_machine.travel("idle")

func handle_dash() -> void:
	_velocity = _dash_direction * move_speed
