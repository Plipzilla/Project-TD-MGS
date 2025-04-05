extends BaseState

func enter(character: CharacterBody2D) -> void:
	character.movement_speed = character.slow_walk_speed

func update(character: CharacterBody2D, _delta: float) -> void:
	character.velocity = character.input_vector * character.movement_speed
	character.move_and_slide()
	
func exit(character: CharacterBody2D) -> void:
	if !character.is_crouching:
		character.movement_speed = character.normal_speed
