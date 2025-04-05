extends CharacterBody2D

@export var movement_speed := 200
var input_vector := Vector2.ZERO

enum State { 
	IDLE,
	WALKING }

var current_state: State = State.IDLE
var states_map := {}

func _ready():
	states_map = {
		State.IDLE: $States/idle_state,
		State.WALKING: $States/walking_state
	}
	change_state(State.IDLE)


func _physics_process(delta: float) -> void:
	handle_input()
	update_state()
	states_map[current_state].update(self, delta)
	update_animation()
	rotate_sprite()


func handle_input():
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()


func update_state():
	if input_vector.length() > 0:
		change_state(State.WALKING)
		
	else:
		change_state(State.IDLE)


func change_state(new_state: State):
	if new_state == current_state:
		return
	
	if states_map.has(current_state):
		states_map[current_state].exit(self)
	
	current_state = new_state
	if states_map.has(current_state):
		states_map[current_state].enter(self)


func update_animation():
	var anim = $AnimatedSprite2D
	if input_vector.length() > 0.1:
		anim.play("walk")
		
	else:
		anim.play("idle")


func rotate_sprite():
	if input_vector.length() > 0.1:
		$AnimatedSprite2D.rotation = input_vector.angle()
