extends Camera3D

var closeDistance = 20.0
var closeDistanceSqr = pow(closeDistance, 2)
var farDistance = 35.0
var farDistanceSqr = pow(farDistance, 2)
var acceleration = 15
var drag = 1.1
var velocity = Vector3.ZERO
var pointToChase = Vector3.ZERO
var baseYPosition = global_position.y

@onready
var ballManager = get_node("/root/BallManager")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	baseYPosition = global_position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#pointToChase = ballManager.peakPosition
	#pointToChase.y /= 2
	#pointToChase += ballManager.currentPosition
	
	pointToChase = (ballManager.landPosition - ballManager.currentPosition) / 2 + ballManager.currentPosition
	
	look_at(pointToChase, Vector3.UP)
	#look_at((ballManager.landPosition - ballManager.currentPosition) / 2 + ballManager.currentPosition, Vector3.UP)
	#look_at(ballManager.landPosition, Vector3.UP)
	
func _physics_process(delta: float) -> void:
	var deltaPosition = pointToChase - global_position
	var deltaNormalized = deltaPosition.normalized()
	var rangeSqrMagnitude = deltaPosition.length_squared()
	
	if closeDistanceSqr > rangeSqrMagnitude || rangeSqrMagnitude > farDistanceSqr:
		velocity += deltaNormalized * acceleration * delta
	else:
		velocity /= drag
	#velocity -= deltaNormalized * velocity.length_squared() * drag * delta
		
	velocity.y = 0
	global_position += velocity * delta
	global_position.y = baseYPosition + ballManager.currentPosition.y
