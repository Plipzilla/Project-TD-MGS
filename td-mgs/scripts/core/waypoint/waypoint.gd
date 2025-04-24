class_name WayPoint extends Marker2D

enum PatrolOpcode {END_OF_SECTION, FACE, GOTO, WAIT}

@export var actions: Array[WayPointOp] = []

func _ready() -> void:
	set_physics_process(false)
