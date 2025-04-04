extends Area2D

@export var speed = 1
var screen_size 

@onready var sprite = $Animated2D_Torso

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("right"):
		velocity.x += 1
		$Animated2D_Torso.play("walk_H")
		$Animated2D_Torso.flip_h = false
		
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		$Animated2D_Torso.play("walk_H")
		$Animated2D_Torso.flip_h = true
	
	if Input.is_action_pressed("down"):
		velocity.y += 1
		$Animated2D_Torso.play("walk_V")
		$Animated2D_Torso.flip_v = false
		
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		$Animated2D_Torso.play("walk_V")
		$Animated2D_Torso.flip_v = true
		
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		sprite.play()
		
	elif Input.is_action_just_released("down") || Input.is_action_just_released("up"):
		$Animated2D_Torso.play("idle_V")
	
	elif Input.is_action_just_released("left") || Input.is_action_just_released("right"):
		$Animated2D_Torso.play("idle_H")
		
	
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size - Vector2(1, 1))
