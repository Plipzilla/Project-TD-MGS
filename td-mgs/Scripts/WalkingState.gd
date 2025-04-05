extends BaseState

func update(character: CharacterBody2D, delta: float) -> void:
	character.velocity = character.input_vector * character.movement_speed
	character.move_and_slide()
