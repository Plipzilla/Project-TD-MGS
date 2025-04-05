extends BaseState

func enter(character: CharacterBody2D) -> void:
	character.velocity = Vector2.ZERO

func update(character: CharacterBody2D, delta: float) -> void:
	character.move_and_slide()
