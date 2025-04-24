class_name EnemyController extends CharacterBody2D

@export var _main_waypoint: WayPoint

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: EnemyStateMachine = $EnemyStateMachine
@onready var patrolling: PatrollingState = $EnemyStateMachine/patrolling
@onready var navAgent: NavigationAgent2D = $NavigationAgent2D

var angle_cone_of_vision: float = deg_to_rad(45.0)
var max_view_distance: float = 800.0
var angle_between_rays: float = deg_to_rad(5.0)

@export var wayPoints: Node2D

func _ready():
	state_machine.initialize(self)
	generate_raycasts()

func _physics_process(_delta):
	# var dir = Vector3()
	# navAgent.target_position = get_global_mouse_position()
	# dir = navAgent.get_next_path_position() - global_position
	# dir = dir.normalized()
	# velocity = velocity.lerp(dir * speed, accel * delta)
	move_and_slide()
	# rotation = dir.angle()

	for ray in get_children():
		if ray is RayCast2D:
			ray.force_raycast_update()
			if ray.is_colliding() and ray.get_collider() is PlayerCharacter:
				# print("Player detected!")
				pass
			else:
				# print("No player detected.")
				pass

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
	rotation = angle
