class_name EnemyController extends CharacterBody2D

@export var _main_waypoint: WayPoint
@export var turn_speed: float = 3.0
@export var angle_threshold: float = 0.05
@export var wayPoints: Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: EnemyStateMachine = $EnemyStateMachine
@onready var patrolling: PatrollingState = $EnemyStateMachine/patrolling
@onready var chasing: ChasingState = $EnemyStateMachine/chasing
@onready var searching: SearchingState = $EnemyStateMachine/searching
@onready var returning: ReturningState = $EnemyStateMachine/returning
@onready var idle: IdleState = $EnemyStateMachine/idle
@onready var navAgent: NavigationAgent2D = $NavigationAgent2D

var angle_cone_of_vision: float = deg_to_rad(45.0)
var max_view_distance: float = 800.0
var angle_between_rays: float = deg_to_rad(5.0)

var target_angle: float = 0.0
var is_turning: bool = false

func _ready():
	state_machine.initialize(self)
	setup_state_connections()
	generate_raycasts()

func setup_state_connections():
	print("State references - patrolling: ", patrolling, " chasing: ", chasing, " searching: ", searching, " returning: ", returning, " idle: ", idle)

	if chasing and searching:
		chasing.search_state = searching
	else:
		print("Cannot connect chasing->searching: chasing=", chasing, " searching=", searching)

	if searching and returning:
		searching.return_state = returning
	else:
		print("Cannot connect searching->returning: searching=", searching, " returning=", returning)

	if returning and patrolling:
		returning.patrol_state = patrolling
	else:
		print("Cannot connect returning->patrolling: returning=", returning, " patrolling=", patrolling)

	if patrolling and idle:
		patrolling.next_state = idle
	else:
		print("Cannot connect patrolling->idle: patrolling=", patrolling, " idle=", idle)

	if idle and patrolling:
		idle.after_idle_state = patrolling
	else:
		print("Cannot connect idle->patrolling: idle=", idle, " patrolling=", patrolling)

func _physics_process(_delta):
	if is_turning:
		process_turning(_delta)
	for ray in get_children():
		if ray is RayCast2D:
			ray.force_raycast_update()
			if ray.is_colliding() and ray.get_collider() is PlayerCharacter:
				state_machine.change_state(chasing)
				pass
			else:
				# print("No player detected.")
				pass
	move_and_slide()

func update_animation(state: String) -> void:
	animation_player.play(state)
	pass

func generate_raycasts():
	var ray_count = int(angle_cone_of_vision / angle_between_rays)
	
	# Get the entity's current forward direction
	var forward_direction = global_transform.basis_xform(Vector2.RIGHT)
	var base_angle = forward_direction.angle()
	
	# Calculate starting angle (leftmost ray of the cone)
	var start_angle = base_angle - (angle_cone_of_vision / 2.0)
	
	for i in range(ray_count):
		var ray = RayCast2D.new()
		var angle = start_angle + (angle_between_rays * i)
		ray.target_position = Vector2.RIGHT.rotated(angle) * max_view_distance
		add_child(ray)

func enemy_patroling():
	state_machine.change_state(patrolling)
	pass

func get_main_way_point() -> WayPoint:
	return _main_waypoint

func process_navigation(speed: float, acceleration: float, friction: float, delta: float) -> void:
	if navAgent.is_navigation_finished():
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		return
	
	var dir: Vector2 = position.direction_to(navAgent.get_next_path_position())
	velocity = velocity.move_toward(dir * speed, acceleration * delta)
	look_at(navAgent.get_next_path_position())

func navigate(dest_position: Vector2):
	navAgent.target_position = dest_position

func turn_to_look_at(angle: float):
	target_angle = wrapf(angle, -PI, PI)
	is_turning = true

func process_turning(delta):
	var current_angle = wrapf(rotation, -PI, PI)
	var angle_diff = shortest_angle_distance(current_angle, target_angle)
	if abs(angle_diff) < angle_threshold:
		rotation = target_angle
		is_turning = false
		return
		
	var step = turn_speed * delta
	
	if abs(step) > abs(angle_diff):
		step = angle_diff
	else:
		step = sign(angle_diff) * step
	
	rotation = wrapf(current_angle + step, -PI, PI)

# Helper function to find shortest angular distance
func shortest_angle_distance(from: float, to: float) -> float:
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference
