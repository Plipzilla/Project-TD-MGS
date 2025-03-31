extends Area2D

@export var speed = 400
var screen_size 

@onready var sprite = $AnimatedSprite2D

func _ready():
	screen_size = get_viewport_rect().size  # Fix: Use .size to get Vector2

func _process(delta):
	var velocity = Vector2.ZERO

	if Input.is_action_pressed("right"):
		velocity.x += 1
		$AnimatedSprite2D.play("walk_side")
		$AnimatedSprite2D.flip_h = false
		
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		
		$AnimatedSprite2D.play("walk_side")
		$AnimatedSprite2D.flip_h = true
		
	if Input.is_action_pressed("down"):
		velocity.y += 1
		$AnimatedSprite2D.play("walk _down")
		
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		$AnimatedSprite2D.play("walk_up")
		
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		sprite.play()
	else:
		$AnimatedSprite2D.play("idle")

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size - Vector2(1, 1))  # Fix: Proper clamping
