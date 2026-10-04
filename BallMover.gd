extends RigidBody3D

var rangeMin = 3
var rangeMax = 21
var horizontalSpeed = 5.2
var rangeMultiplier = 0.5
var launchBearing = 270
var launchRange = GetRange()
var launchBearingVector = GetLaunchVector()
var yVelocity = GetYVelocity()
var goneUnder = false
@onready
var ballManager = get_node("/root/BallManager")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	launchRange = GetRange()
	launchBearingVector = GetLaunchVector()
	yVelocity = GetYVelocity()
	
	ballManager.currentPosition = global_position
	ballManager.landPosition = global_position + launchBearingVector * launchRange
	ballManager.peakPosition = GetPeakPosition()
	#pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var inputDelta : float = 0
	if Input.is_action_just_pressed("RangeIncrease"):
		inputDelta = 0.05
	if Input.is_action_just_pressed("RangeDecrease"):
		inputDelta = -0.05
		
	if inputDelta != 0:
		rangeMultiplier = clamp(rangeMultiplier + inputDelta, 0, 1)
		launchRange = GetRange()
		yVelocity = GetYVelocity()
		
	ballManager.currentPosition = global_position
	ballManager.landPosition = global_position + launchBearingVector * launchRange
	ballManager.peakPosition = GetPeakPosition()

func _input(event):
	if event is InputEventMouseMotion:
		launchBearing -= event.relative.x / 1.7
		
		if launchBearing > 360:
			launchBearing -= 360
		elif launchBearing < 0:
			launchBearing += 360
		
		launchBearingVector = GetLaunchVector()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Launch") && ballManager.hitGround:
		ballManager.timeOfFlight = horizontalSpeed
		
		linear_velocity = launchBearingVector * horizontalSpeed
		linear_velocity.y = yVelocity
		#linear_velocity *= 1.02
		
	if global_position.y <= -20:
		global_position = Vector3(0, 2, 0)
		goneUnder = true
		
func _integrate_forces(state: PhysicsDirectBodyState3D):
	if goneUnder:
		linear_velocity = Vector3.ZERO
		goneUnder = false

func GetRange() -> float:
	return rangeMin + rangeMultiplier * (rangeMax - rangeMin)

func GetYVelocity() -> float:
	return launchRange / 2 * -get_gravity().y / horizontalSpeed

func GetLaunchVector() -> Vector3:
	var sinComponent : float = sin(deg_to_rad(launchBearing))
	var cosComponent : float = sqrt(1 - sinComponent * sinComponent) 

	if launchBearing > 90 && launchBearing < 270:
		cosComponent = -cosComponent

	return Vector3(sinComponent, 0, cosComponent)

func GetPeakPosition() -> Vector3:
	var peakPosition = (launchBearingVector) * launchRange / 2
	peakPosition.y = pow(yVelocity, 2) / -get_gravity().y
	return peakPosition
