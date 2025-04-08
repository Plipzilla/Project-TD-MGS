class_name ActionNode extends BehaviorNode

var action_name: BEnums.ActionType

func _init(name: BEnums.ActionType) -> void:
    action_name = name


func tick() -> int:
    match action_name:
        BEnums.ActionType.ATTACK:
           return _attack_player()
        BEnums.ActionType.CHASE:
            return _chase_player()
        BEnums.ActionType.PATROL:
            return _patrol_area()
    return BEnums.NodeStatus.FAILURE


func _attack_player() -> BEnums.NodeStatus:
    print("Performing attack action")
    # Implement attack logic here
    return BEnums.NodeStatus.SUCCESS

func _chase_player() -> BEnums.NodeStatus:
    print("Performing chase action")
    # Implement chase logic here
    return BEnums.NodeStatus.RUNNING

func _patrol_area() -> BEnums.NodeStatus:
    print("Performing patrol action")
    # Implement patrol logic here
    return BEnums.NodeStatus.RUNNING