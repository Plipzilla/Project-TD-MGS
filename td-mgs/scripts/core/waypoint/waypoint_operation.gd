class_name WayPointOp extends Resource


enum PatrolOpcode {END_OF_SECTION, FACE, GOTO, WAIT}
@export var op: PatrolOpcode
@export var direction: String = ""
@export var go_to_dest: String = ""