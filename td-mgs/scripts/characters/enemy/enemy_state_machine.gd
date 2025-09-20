class_name EnemyStateMachine extends Node


var states : Array[ EnemyState ]
var prev_state : EnemyState
var current_state : EnemyState


func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	pass



func _process(delta):
	change_state( current_state.process( delta ) )
	pass



func _physics_process(delta):
	change_state( current_state.physics( delta ) )
	pass



func initialize( _enemy : EnemyController ) -> void:
	states = []
	
	for c in get_children():
		if c is EnemyState:
			states.append( c )
	
	for s in states:
		s.actor = _enemy
		s.state_machine = self
		s.init()
	
	if states.size() > 0:
		change_state( states[0] )
		process_mode = Node.PROCESS_MODE_INHERIT
	pass



func change_state( new_state : EnemyState ) -> void:

	if new_state == null || new_state == current_state:
		return

	var prev_state_name = current_state.get_script().get_global_name() if current_state else "null"
	var new_state_name = new_state.get_script().get_global_name()

	print("Enemy State Transition: ", prev_state_name, " -> ", new_state_name)

	if current_state:
		current_state.exit()

	prev_state = current_state
	current_state = new_state
	current_state.enter()
