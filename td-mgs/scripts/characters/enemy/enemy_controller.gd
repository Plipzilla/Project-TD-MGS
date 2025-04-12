class_name EnemyController extends CharacterBody2D

@export var rotation_speed = 10.0
@export var speed = 300
@export var accel = 7

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: EnemyStateMachine = $EnemyStateMachine
@onready var wandering: WanderingState = $EnemyStateMachine/wandering
@onready var nav: NavigationAgent2D = $NavigationAgent2D

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
var direction: Vector2 = Vector2.ZERO
var cardinal_direction: Vector2 = Vector2.DOWN

var angle_cone_of_vision: float = deg_to_rad(45.0)
var max_view_distance: float = 800.0
var angle_between_rays: float = deg_to_rad(5.0)

var behavior_tree: BehaviorNode

func _ready():
	state_machine.initialize(self)
	generate_raycasts()

func _physics_process(delta):
	var dir = Vector3()
	nav.target_position = get_global_mouse_position()
	dir = nav.get_next_path_position() - global_position
	dir = dir.normalized()
	
	velocity = velocity.lerp(dir * speed, accel * delta)
	
	move_and_slide()
	rotation = dir.angle()

	for ray in get_children():
		if ray is RayCast2D:
			ray.force_raycast_update()
			if ray.is_colliding() and ray.get_collider() is PlayerCharacter:
				print("Player detected!")
			else:
				print("No player detected.")

func update_animation(state: String) -> void:
	animation_player.play(state)
	pass

func set_direction(_new_direction: Vector2) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false
	
	var direction_id: int = int(round(
			(direction + cardinal_direction * 0.1).angle()
			/ TAU * DIR_4.size()
	))
	var new_dir = DIR_4[direction_id]
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	return true

func generate_raycasts():
	var ray_count = int(angle_cone_of_vision / angle_between_rays)
	for i in range(ray_count):
		var ray = RayCast2D.new()
		var angle: float = angle_between_rays * (i - ray_count / 2.0)
		ray.target_position = Vector2.UP.rotated(angle) * max_view_distance
		add_child(ray)

func enemy_patroling():
	state_machine.change_state(wandering)
	pass
