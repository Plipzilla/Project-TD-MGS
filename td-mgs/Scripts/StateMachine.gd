extends CharacterBody2D


@export var normal_speed := 200
@export var slow_walk_speed := 100
@export var crouch_speed := 70
var movement_speed
var is_crouching := false
var is_slow_walking := false
var input_vector := Vector2.ZERO

enum State { 
	IDLE,
	WALKING,
	SLOW_WALKING,
	CROUCHING
	 }

var current_state: State = State.IDLE
var states_map := {}

func _ready():
	states_map = {
		State.IDLE: $States/idle_state,
		State.WALKING: $States/walking_state,
		State.CROUCHING: $States/crouching_state,
		State.SLOW_WALKING: $States/sneak_state
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
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	if Input.is_action_just_pressed("crouch"):
		is_crouching = !is_crouching
		update_state()
	
	is_slow_walking = Input.is_action_pressed("slow_walking")
	
	if Input.is_action_just_released("slow_walking"):
		update_state()

func update_state():
	if input_vector.length() > 0:

		if is_crouching:
			change_state(State.CROUCHING)
		
		elif is_slow_walking:
			change_state(State.SLOW_WALKING)
			
		else:
			movement_speed = normal_speed
			change_state(State.WALKING)
		
	else:
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

func apply_movement(delta):
	match current_state:
		State.WALKING:
			velocity = input_vector * movement_speed
		
		State.SLOW_WALKING:
			velocity = input_vector * slow_walk_speed
			
		State.CROUCHING:
			velocity = input_vector * crouch_speed 
			velocity = Vector2.ZERO
			
	move_and_slide()

func update_animation():
	var anim = $AnimatedSprite2D
	
	if is_crouching:
		anim.play("crouch")
	
	elif current_state == State.SLOW_WALKING:
		pass #we'll eventually add animations here too
		
	elif input_vector.length() > 0.1:
			anim.play("walk")
				
	else:
		anim.play("idle")

func rotate_sprite():
	if input_vector.length() > 0.1:
		$AnimatedSprite2D.rotation = input_vector.angle()
