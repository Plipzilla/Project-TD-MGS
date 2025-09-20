class_name AttackState extends EnemyState

@export var anim_name: String = "attack"
@export var attack_range: float = 80.0
@export var attack_damage: float = 10.0

@export_category("AI")
@export var attack_duration: float = 1.0
@export var attack_cooldown: float = 1.5
@export var chase_state: EnemyState
@export var search_state: EnemyState

var target_player: PlayerCharacter = null
var attack_timer: float = 0.0
var cooldown_timer: float = 0.0
var is_attacking: bool = false
var has_dealt_damage: bool = false

func enter() -> void:
	find_player()
	attack_timer = 0.0
	cooldown_timer = 0.0
	is_attacking = false
	has_dealt_damage = false
	actor.velocity = Vector2.ZERO

	if target_player:
		actor.turn_to_look_at(actor.global_position.angle_to_point(target_player.global_position))
		actor.update_animation(anim_name)

func exit() -> void:
	target_player = null
	is_attacking = false
	has_dealt_damage = false

func process(_delta: float) -> EnemyState:
	if not target_player:
		find_player()
		if not target_player:
			return search_state

	var distance_to_player = get_distance_to_player_edge()

	if distance_to_player > attack_range:
		return chase_state

	if not is_attacking and cooldown_timer <= 0.0:
		start_attack()

	if is_attacking:
		attack_timer += _delta

		if attack_timer >= attack_duration * 0.5 and not has_dealt_damage:
			deal_damage()
			has_dealt_damage = true

		if attack_timer >= attack_duration:
			end_attack()

	if cooldown_timer > 0.0:
		cooldown_timer -= _delta

	return null

func physics(_delta: float) -> EnemyState:
	actor.velocity = Vector2.ZERO
	return null

func start_attack() -> void:
	is_attacking = true
	attack_timer = 0.0
	has_dealt_damage = false
	actor.update_animation(anim_name)

func end_attack() -> void:
	is_attacking = false
	attack_timer = 0.0
	cooldown_timer = attack_cooldown

func deal_damage() -> void:
	if not target_player:
		return

	var distance_to_player = get_distance_to_player_edge()

	if distance_to_player <= attack_range:
		if target_player.has_method("take_damage"):
			target_player.take_damage(attack_damage)
		print("Enemy dealt ", attack_damage, " damage to player")

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