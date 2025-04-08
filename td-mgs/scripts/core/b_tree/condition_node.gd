class_name ConditionNode extends BehaviorNode

var condition_name: String

func _init(name: String):
	condition_name = name

func tick() -> int:
	# Override in specific implementations
	match condition_name:
		"IsPlayerVisible":
			return _is_player_visible()
		"IsPlayerInRange":
			return _is_player_in_range()
	return BEnums.NodeStatus.FAILURE

func _is_player_visible() -> int:
	# Would check game state
	print("Checking if player is visible")
	return BEnums.NodeStatus.SUCCESS # For example purposes

func _is_player_in_range() -> int:
	# Would check game state
	print("Checking if player is in attack range")
	return BEnums.NodeStatus.SUCCESS # For example purposes
