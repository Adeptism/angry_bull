extends KinematicBody2D
class_name Actor


# ==========	Exported variables	============================================================================
export var move_speed: float = 250.0


# ==========	Private variables	============================================================================
var _input: Vector2 = Vector2.ZERO
var _velocity: Vector2 = Vector2.ZERO
var _direction: Vector2 = Vector2.LEFT
onready var _state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")
onready var _sprite_group: Node2D = find_node("sprite")


# ==========	Frame & physics update	========================================================================
func _process(delta: float) -> void:
	# Acquire input
	process_input()
	# Perform calculations
	calculate_velocity()
	# Call animations
	set_animation()
	# Apply orientation
	set_orientation()

func _physics_process(delta: float) -> void:
	# Apply movement
	move_and_slide(_velocity)


# ==========	User-defined functions	========================================================================
func process_input() -> void:
	pass

func calculate_velocity() -> void:
	pass

func set_animation() -> void:
	pass

func set_orientation() -> void:
	if _direction == Vector2.LEFT: _sprite_group.scale.x = abs(_sprite_group.scale.x)
	elif _direction == Vector2.RIGHT: _sprite_group.scale.x = -abs(_sprite_group.scale.x)
