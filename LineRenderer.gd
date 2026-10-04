extends Node3D

@onready
var ballManager = get_node("/root/BallManager")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ballManager.hitGround:
		$".".curve.set_point_position(0, ballManager.currentPosition)
		$".".curve.set_point_position(1, ballManager.landPosition)
		
		$".".curve.set_point_out(0, ballManager.peakPosition)
		$".".curve.set_point_out(1, -ballManager.peakPosition)
	else:
		pass
		#$".".curve.set_point_position(0, Vector3.ONE)
		#$".".curve.set_point_position(1, Vector3.ONE)
		
		#$".".curve.set_point_out(0, Vector3.ONE)
		#$".".curve.set_point_out(1, Vector3.ONE)
