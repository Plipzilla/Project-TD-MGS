class_name WayPoint extends Marker2D

enum PatrolOpcode {END_OF_SECTION, FACE, GOTO, WAIT}

@export var actions: Array[WayPointOp] = []
signal navigation_requested(next_patrol_point: WayPointOp, next_section: int)

func _ready() -> void:
	set_physics_process(false)
