class_name EnemyConditionNode extends BehaviorNode

var condition_name: EnemyEnums.ConditionType

func _init(name: EnemyEnums.ConditionType):
	condition_name = name

func tick() -> int:
	# Override in specific implementations
	match condition_name:
		EnemyEnums.ConditionType.IS_PLAYER_VISIBLE:
			return _is_player_visible()
		EnemyEnums.ConditionType.IS_PLAYER_IN_RANGE:
			return _is_player_in_range()
	return BEnums.NodeStatus.FAILURE

func _is_player_visible() -> int:
	# Would check game state
	print("Checking if player is visible")
	return BEnums.NodeStatus.FAILURE

func _is_player_in_range() -> int:
	# Would check game state
	print("Checking if player is in attack range")
	return BEnums.NodeStatus.FAILURE
