extends Actor


# ==========	Exported variables	============================================================================
export var max_speed: float = 1000.0
export var turn_speed: float = PI/16
export var brake_factor: float = 0.2
export var charge_degree: float = 5.0


# ==========	Private variables	============================================================================
var _angle: float = 0.0
onready var _target: Node2D = get_parent().find_node("Player")


# ==========	Callback functions	============================================================================
func _ready() -> void: _input = _direction


# ==========	User-defined functions	========================================================================
func process_input() -> void:
	# Set movement input towards the target
	if _target:
		var target: Vector2 = _target.position - position
		_angle = _input.angle_to(target)
		var signed: float = 1.0 if _angle >= 0.0 else -1.0
		_input = _input.rotated(turn_speed * signed).normalized()
		# Set direction
		_direction = Vector2(1.0 if target.x >= 0.0 else -1.0, 0.0)

func calculate_velocity() -> void:
	if abs(_angle) <= charge_degree: _velocity += _input * move_speed * get_physics_process_delta_time()
	handle_angle()
	if _velocity.length_squared() > (max_speed * max_speed): _velocity = _velocity.normalized() * max_speed

func set_animation() -> void:
	# Apply animation
	_state_machine.travel("movement")

func handle_angle() -> void:
	var angle_factor: float = clamp((abs(_angle) / PI), 0.0, 1.0)
	_velocity -= _velocity * (brake_factor * angle_factor)
