class_name PatrollingState extends EnemyState

@export var anim_name: String = "walk"
@export var patrol_speed: float = 100.0
@export var patrol_acceleration: float = 100.0
@export var patrol_friction: float = 900.0

@export_category("AI")
@export var state_animation_duration: float = 0.5
@export var state_cycles_min: int = 1
@export var state_cycles_max: int = 3
@export var next_state: EnemyState

var path: Dictionary = {}
var _waypoint: WayPoint = null
var _action_index = 0
var _waited_time: float = 0.0

func enter() -> void:
	set_waypoint(actor._main_waypoint)
	get_all_current_waypoints()
	pass

## What happens when the enemy exits this State?
func exit() -> void:
	set_waypoint(null)
	pass


## What happens during the _process update in this State?
func process(_delta: float) -> EnemyState:
	return null


## What happens during the _physics_process update in this State?
func physics(_delta: float) -> EnemyState:
	if not _waypoint:
		return next_state
	_handle_waypoint_actions(_delta)
	update_navigation()
	actor.process_navigation(patrol_speed, patrol_acceleration, patrol_friction, _delta)
	return null

func set_waypoint(waypoint: WayPoint) -> void:
	_waypoint = waypoint
	pass

func update_navigation() -> void:
	if actor.navAgent.is_navigation_finished():
		if actor.global_position.distance_to(_waypoint.global_position) > 20.0:
			actor.navigate(_waypoint.global_position)
	pass

func get_all_current_waypoints():
	for child in actor.wayPoints.get_children():
		if child is WayPoint:
			path[str(actor.wayPoints.get_path_to(child))] = child
			pass
	pass

func _handle_waypoint_actions(_delta: float):
	if !actor.navAgent.is_navigation_finished():
		return
	if _action_index < 0 or _action_index >= len(_waypoint.actions):
		return
	var action = _waypoint.actions[_action_index]

	match action.op:
		WayPoint.PatrolOpcode.END_OF_SECTION:
			_action_index = 0
			_waypoint = actor._main_waypoint
		WayPoint.PatrolOpcode.GOTO:
			if action.go_to_dest != "":
				var go_to = path.get(action.go_to_dest)
				_waypoint = go_to
				_action_index = 0
				return
			_action_index += 1
		WayPoint.PatrolOpcode.WAIT:
			_waited_time += _delta;

			if _waited_time >= action.duration:
				_waited_time = 0
				_action_index += 1
		WayPoint.PatrolOpcode.FACE:
			actor.turn_to_look_at(action.convert_direction())
			_action_index += 1
			pass
	return
