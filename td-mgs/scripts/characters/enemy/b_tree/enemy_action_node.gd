class_name EnemyActionNode extends BehaviorNode

var action_name: EnemyEnums.ActionType
var  enemy_controller: EnemyController

func _init(name: EnemyEnums.ActionType, controller: EnemyController) -> void:
	action_name = name
	enemy_controller = controller


func tick() -> int:
	match action_name:
		EnemyEnums.ActionType.ATTACK:
			return _attack_player()
		EnemyEnums.ActionType.CHASE:
			return _chase_player()
		EnemyEnums.ActionType.PATROL:
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
	enemy_controller.enemy_patroling()
	return BEnums.NodeStatus.RUNNING
