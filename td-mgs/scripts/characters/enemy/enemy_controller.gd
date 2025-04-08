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

var behavior_tree: BehaviorNode

func _ready():
	state_machine.initialize(self)
	behavior_tree = create_behavior_tree()

func _process(_delta):
	behavior_tree.tick()

func _physics_process(delta):
	var  dir = Vector3()
	nav.target_position = get_global_mouse_position()
	dir = nav.get_next_path_position() - global_position
	dir = dir.normalized()
	
	velocity = velocity.lerp(dir * speed, accel * delta)
	
	move_and_slide()
	rotation = dir.angle()

func create_behavior_tree() -> BehaviorNode:
	# Create root selector
	var root = SelectorNode.new()
	
	# Attack sequence: if player visible AND in range, then attack
	var attack_sequence = SequenceNode.new()
	attack_sequence.add_child(EnemyConditionNode.new(EnemyEnums.ConditionType.IS_PLAYER_VISIBLE))
	attack_sequence.add_child(EnemyConditionNode.new(EnemyEnums.ConditionType.IS_PLAYER_IN_RANGE))
	attack_sequence.add_child(EnemyActionNode.new(EnemyEnums.ActionType.ATTACK, self))
	
	# Chase sequence: if player visible, then chase
	var chase_sequence = SequenceNode.new()
	chase_sequence.add_child(EnemyConditionNode.new(EnemyEnums.ConditionType.IS_PLAYER_VISIBLE))
	chase_sequence.add_child(EnemyActionNode.new(EnemyEnums.ActionType.CHASE, self))
	
	# Patrol action: fallback behavior
	var patrol_action = EnemyActionNode.new(EnemyEnums.ActionType.PATROL, self)
	
	# Add all behaviors to root selector
	root.add_child(attack_sequence)
	root.add_child(chase_sequence)
	root.add_child(patrol_action)
	
	return root

func update_animation(state: String) -> void:
	animation_player.play(state)
	pass

func rotate_character(direction: Vector2, delta: float) -> void:
	if direction != Vector2.ZERO:
		# Calculate the target rotation angle based on direction
		var target_angle = direction.angle()
		
		# Get the current rotation angle
		var current_angle = rotation
		
		# Find the shortest angle to rotate
		var angle_diff = wrapf(target_angle - current_angle, -PI, PI)
		
		# Apply smooth rotation
		rotation += angle_diff * rotation_speed * delta

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


func enemy_patroling():
	state_machine.change_state(wandering)
	pass
