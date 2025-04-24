class_name EnemyState extends Node


## Stores a reference to the actor that this state belongs to
var actor : EnemyController
var state_machine : EnemyStateMachine


## What happens when we initialize this state?
func init() -> void:
	pass


## What happens when the actor enters this State?
func enter() -> void:
	pass


## What happens when the actor exits this State?
func exit() -> void:
	pass


## What happens during the _process update in this State?
func process( _delta : float ) -> EnemyState:
	return null


## What happens during the _physics_process update in this State?
func physics( _delta : float ) -> EnemyState:
	return null
