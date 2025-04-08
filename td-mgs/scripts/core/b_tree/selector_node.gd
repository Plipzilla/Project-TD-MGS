class_name SelectorNode extends BehaviorNode

var children: Array[BehaviorNode] = []

func add_child(node: BehaviorNode) -> void:
	children.append(node)

func tick() -> int:
	for child in children:
		var status = child.tick()
		
		if status != BEnums.NodeStatus.FAILURE:
			# Child either succeeded or is still running
			return status
	
	# All children failed
	return BEnums.NodeStatus.FAILURE