class_name WayPointOp extends Resource


enum PatrolOpcode {END_OF_SECTION, FACE, GOTO, WAIT}
enum TurnDirection {UP, DOWN, RIGHT, LEFT}

@export var op: PatrolOpcode
@export var direction: TurnDirection
@export var go_to_dest: String = ""
@export var duration: float = 0.0

func convert_direction() -> float:
    var angle: float
    
    match direction:
        TurnDirection.UP:
            angle = Vector2.UP.angle()
        TurnDirection.DOWN:
            angle = Vector2.DOWN.angle()
        TurnDirection.RIGHT:
            angle = Vector2.RIGHT.angle()
        TurnDirection.LEFT:
            angle = Vector2.LEFT.angle()
    return angle