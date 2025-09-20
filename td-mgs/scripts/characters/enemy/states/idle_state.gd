class_name IdleState extends EnemyState

@export var anim_name : String = "idle"

@export_category("AI")
@export var state_duration_min : float = 0.5
@export var state_duration_max : float = 1.5
@export var after_idle_state : Node

var _timer : float = 0.

## What happens when the enemy enters this State?
func enter() -> void:
	actor.velocity = Vector2.ZERO
	_timer = randf_range( state_duration_min, state_duration_max )
	actor.update_animation( anim_name )
	pass
	
func process( _delta : float ) -> EnemyState:
	_timer -= _delta
	if _timer <= 0:
		return after_idle_state as EnemyState
	return null
