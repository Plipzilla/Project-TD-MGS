extends BaseState

func enter(character: CharacterBody2D):
	character.movement_speed = character.running_speed

func update(character: CharacterBody2D, delta: float):
	if character.input_vector.length() == 0:
		character.is_running = false  # This ensures sprint is properly disabled
		character.change_state(PlayerCharacter.State.IDLE)
		return
	
	if !character.is_running:
		character.change_state(PlayerCharacter.State.WALKING)
		return
	
	character.velocity = character.input_vector * character.movement_speed
	character.move_and_slide()
	
func exit(character: CharacterBody2D):
	character.movement_speed = character.normal_speed
