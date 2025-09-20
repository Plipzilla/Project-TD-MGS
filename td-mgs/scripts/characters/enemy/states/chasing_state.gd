class_name ChasingState extends EnemyState

@export var anim_name: String = "walk"
@export var chase_speed: float = 300.0
@export var chase_acceleration: float = 200.0
@export var chase_friction: float = 1000.0

@export_category("AI")
@export var chase_timeout: float = 5.0
@export var min_chase_distance: float = 50.0
@export var attack_range: float = 80.0
@export var search_state: EnemyState
@export var attack_state: EnemyState

var target_player: PlayerCharacter = null
var chase_timer: float = 0.0
var last_known_position: Vector2

func enter() -> void:
	chase_timer = 0.0
	find_player()
	if target_player:
		last_known_position = target_player.global_position
	actor.update_animation(anim_name)

func exit() -> void:
	target_player = null
	chase_timer = 0.0

func process(_delta: float) -> EnemyState:
	chase_timer += _delta

	if chase_timer >= chase_timeout:
		return search_state

	return null

func physics(_delta: float) -> EnemyState:
	if not target_player:
		find_player()
		if not target_player:
			return search_state

	if can_see_player():
		last_known_position = target_player.global_position
		chase_timer = 0.0

		var distance_to_player = get_distance_to_player_edge()

		print({"distance_to_player": distance_to_player, "attack_range": attack_range}, distance_to_player <= attack_range)
		if distance_to_player <= attack_range and attack_state:
			return attack_state

		if distance_to_player <= min_chase_distance:
			actor.velocity = Vector2.ZERO
			return null

		actor.navigate(target_player.global_position)
	else:
		actor.navigate(last_known_position)

	actor.process_navigation(chase_speed, chase_acceleration, chase_friction, _delta)

	if actor.navAgent.is_navigation_finished() and actor.global_position.distance_to(last_known_position) < 30.0:
		return search_state

	return null

func find_player() -> void:
	for ray in actor.get_children():
		if ray is RayCast2D:
			ray.force_raycast_update()
			if ray.is_colliding() and ray.get_collider() is PlayerCharacter:
				target_player = ray.get_collider()
				return

func can_see_player() -> bool:
	if not target_player:
		return false

	for ray in actor.get_children():
		if ray is RayCast2D:
			ray.force_raycast_update()
			if ray.is_colliding() and ray.get_collider() == target_player:
				return true

	return false

func get_distance_to_player_edge() -> float:
	if not target_player:
		return 999999.0

	var actor_shape = actor.get_node("CollisionShape2D") if actor.has_node("CollisionShape2D") else null
	var player_shape = target_player.get_node("CollisionShape2D") if target_player.has_node("CollisionShape2D") else null

	var actor_radius = 32.0
	var player_radius = 32.0

	if actor_shape and actor_shape.shape is CircleShape2D:
		actor_radius = actor_shape.shape.radius
	elif actor_shape and actor_shape.shape is RectangleShape2D:
		var rect_size = actor_shape.shape.size
		actor_radius = max(rect_size.x, rect_size.y) * 0.5

	if player_shape and player_shape.shape is CircleShape2D:
		player_radius = player_shape.shape.radius
	elif player_shape and player_shape.shape is RectangleShape2D:
		var rect_size = player_shape.shape.size
		player_radius = max(rect_size.x, rect_size.y) * 0.5

	var center_distance = actor.global_position.distance_to(target_player.global_position)
	var edge_distance = center_distance - actor_radius - player_radius

	return max(0.0, edge_distance)
