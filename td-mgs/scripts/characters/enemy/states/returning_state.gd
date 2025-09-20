class_name ReturningState extends EnemyState

@export var anim_name: String = "walk"
@export var return_speed: float = 250.0
@export var return_acceleration: float = 150.0
@export var return_friction: float = 700.0

@export_category("AI")
@export var arrival_threshold: float = 50.0
@export var patrol_state: EnemyState

var target_position: Vector2
var has_target: bool = false

func enter() -> void:
	set_return_target()
	actor.update_animation(anim_name)
	if can_see_player():
		var chasing_state = find_chasing_state()
		if chasing_state:
			state_machine.change_state(chasing_state)
			return

func exit() -> void:
	has_target = false

func process(_delta: float) -> EnemyState:
	if can_see_player():
		var chasing_state = find_chasing_state()
		if chasing_state:
			return chasing_state

	return null

func physics(_delta: float) -> EnemyState:
	if not has_target:
		return patrol_state

	actor.navigate(target_position)
	actor.process_navigation(return_speed, return_acceleration, return_friction, _delta)

	if actor.navAgent.is_navigation_finished() and actor.global_position.distance_to(target_position) <= arrival_threshold:
		return patrol_state

	return null

func set_return_target() -> void:
	if actor._main_waypoint:
		target_position = actor._main_waypoint.global_position
		has_target = true
	else:
		has_target = false

func can_see_player() -> bool:
	for ray in actor.get_children():
		if ray is RayCast2D:
			ray.force_raycast_update()
			if ray.is_colliding() and ray.get_collider() is PlayerCharacter:
				return true
	return false

func find_chasing_state() -> EnemyState:
	for state in state_machine.states:
		if state is ChasingState:
			return state
	return null
