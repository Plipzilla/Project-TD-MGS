class_name SearchingState extends EnemyState

@export var anim_name: String = "walk"
@export var search_speed: float = 150.0
@export var search_acceleration: float = 100.0
@export var search_friction: float = 500.0

@export_category("AI")
@export var search_duration: float = 8.0
@export var search_radius: float = 200.0
@export var wait_time_per_spot: float = 2.0
@export var num_search_points: int = 4
@export var return_state: EnemyState

var search_timer: float = 0.0
var current_search_point: int = 0
var search_points: Array[Vector2] = []
var initial_position: Vector2
var wait_timer: float = 0.0
var is_waiting: bool = false

func enter() -> void:
	search_timer = 0.0
	current_search_point = 0
	wait_timer = 0.0
	is_waiting = false
	initial_position = actor.global_position
	generate_search_points()
	actor.update_animation(anim_name)

func exit() -> void:
	search_points.clear()
	search_timer = 0.0
	current_search_point = 0
	is_waiting = false

func process(_delta: float) -> EnemyState:
	search_timer += _delta

	if search_timer >= search_duration:
		return return_state

	if can_see_player():
		return state_machine.states.filter(func(s): return s is ChasingState)[0] if state_machine.states.any(func(s): return s is ChasingState) else null

	return null

func physics(_delta: float) -> EnemyState:
	if search_points.is_empty():
		return return_state

	if is_waiting:
		wait_timer += _delta
		actor.velocity = Vector2.ZERO

		if wait_timer >= wait_time_per_spot:
			is_waiting = false
			wait_timer = 0.0
			current_search_point += 1

			if current_search_point >= search_points.size():
				return return_state
	else:
		if current_search_point < search_points.size():
			var target_point = search_points[current_search_point]
			actor.navigate(target_point)
			actor.process_navigation(search_speed, search_acceleration, search_friction, _delta)

			if actor.navAgent.is_navigation_finished() and actor.global_position.distance_to(target_point) < 30.0:
				is_waiting = true
				actor.turn_to_look_at(get_random_look_angle())
		else:
			return return_state

	return null

func generate_search_points() -> void:
	search_points.clear()

	for i in range(num_search_points):
		var angle = (2.0 * PI * i) / num_search_points
		var offset = Vector2(cos(angle), sin(angle)) * search_radius
		var search_point = initial_position + offset
		search_points.append(search_point)

func can_see_player() -> bool:
	for ray in actor.get_children():
		if ray is RayCast2D:
			ray.force_raycast_update()
			if ray.is_colliding() and ray.get_collider() is PlayerCharacter:
				return true
	return false

func get_random_look_angle() -> float:
	return randf() * 2.0 * PI
