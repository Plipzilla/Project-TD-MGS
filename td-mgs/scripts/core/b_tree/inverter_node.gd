class_name InverterNode extends BehaviorNode

var child: BehaviorNode

func _init(node: BehaviorNode):
	child = node

func tick() -> int:
	var status = child.tick()
	
	match status:
		BEnums.NodeStatus.SUCCESS:
			return BEnums.NodeStatus.FAILURE
		BEnums.NodeStatus.FAILURE:
			return BEnums.NodeStatus.SUCCESS
		_:
			return status