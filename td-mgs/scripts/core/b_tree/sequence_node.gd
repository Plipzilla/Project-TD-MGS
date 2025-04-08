class_name SequenceNode extends BehaviorNode

var children: Array[BehaviorNode] = []

func add_child(node: BehaviorNode) -> void:
	children.append(node)

func tick() -> int:
	for child in children:
		var status = child.tick()
		
		if status != BEnums.NodeStatus.SUCCESS:
			# Child either failed or is still running
			return status
	
	# All children succeeded
	return BEnums.NodeStatus.SUCCESS
