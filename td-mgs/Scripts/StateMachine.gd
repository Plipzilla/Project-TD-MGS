extends CharacterBody2D
class_name PlayerCharacter 

@export var normal_speed := 200
@export var running_speed := 500
@export var slow_walk_speed := 100
@export var crouch_speed := 70

var movement_speed
var is_running := 		false
var is_crouching := 	false
var is_slow_walking := 	false
var input_vector := Vector2.ZERO

enum State { 
	IDLE,
	WALKING,
	SLOW_WALKING,
	CROUCHING,
	RUNNING
	 }
var current_state: State = State.IDLE
var states_map := {}


func _ready():
	states_map = {
		State.IDLE:			$States/idle_state,
		State.WALKING: 		$States/walking_state,
		State.CROUCHING: 	$States/crouching_state,
		State.SLOW_WALKING:	$States/sneak_state,
		State.RUNNING:		$States/running_state
	}
	change_state(State.IDLE)
	movement_speed = normal_speed


func _physics_process(delta: float) -> void:
	handle_input()
	update_state()
	states_map[current_state].update(self, delta)
	update_animation()
	rotate_sprite()


func handle_input():
	input_vector = Vector2.ZERO
	input_vector = input_vector.normalized()
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	is_slow_walking = Input.is_action_pressed("slow_walking")
	if Input.is_action_just_released("slow_walking"):
		update_state()

	if Input.is_action_just_pressed("crouch"):
		is_crouching = !is_crouching
		update_state()

	if Input.is_action_just_pressed("sprint"):
		if input_vector.length() > 0:
			is_running = true
		else:
			is_running = false


func update_state():
	if is_crouching || is_slow_walking:
		is_running = false

	if input_vector.length() > 0:
		if is_crouching:
			change_state(State.CROUCHING)

		elif is_slow_walking:
			change_state(State.SLOW_WALKING)

		elif is_running:
			change_state(State.RUNNING)

		else:
			change_state(State.WALKING)

	else:
		is_running = false
		if is_crouching:
			change_state(State.CROUCHING)	
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
	
	if is_crouching:
		anim.play("crouch")
	
	elif current_state == State.RUNNING:
		anim.play("run")
	
	elif current_state == State.SLOW_WALKING:
		anim.play("sneak")
		
	elif input_vector.length() > 0.1:
		anim.play("walk")
				
	else:
		anim.play("idle")


func rotate_sprite():
	if input_vector.length() > 0.1:
		$AnimatedSprite2D.rotation = input_vector.angle()
