class_name EnemyController
extends CharacterBody2D

var behavior_tree: BehaviorNode

func _ready():
	behavior_tree = create_behavior_tree()

func _process(delta):
	behavior_tree.tick()

func create_behavior_tree() -> BehaviorNode:
	# Create root selector
	var root = SelectorNode.new()
	
	# Attack sequence: if player visible AND in range, then attack
	var attack_sequence = SequenceNode.new()
	attack_sequence.add_child(ConditionNode.new("IsPlayerVisible"))
	attack_sequence.add_child(ConditionNode.new("IsPlayerInRange"))
	attack_sequence.add_child(ActionNode.new(BEnums.ActionType.ATTACK))
	
	# Chase sequence: if player visible, then chase
	var chase_sequence = SequenceNode.new()
	chase_sequence.add_child(ConditionNode.new("IsPlayerVisible"))
	chase_sequence.add_child(ActionNode.new(BEnums.ActionType.CHASE))
	
	# Patrol action: fallback behavior
	var patrol_action = ActionNode.new(BEnums.ActionType.PATROL)
	
	# Add all behaviors to root selector
	root.add_child(attack_sequence)
	root.add_child(chase_sequence)
	root.add_child(patrol_action)
	
	return root