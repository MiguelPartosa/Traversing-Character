extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var mouseSens:float = 0.05
@export var lerpVal:float = 0.15

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var armature = $root
@onready var springArmPivot = $SpringArmPivot
@onready var springArm = $SpringArmPivot/SpringArm3D
@onready var animTree = $AnimationTree

func _ready() -> void:
	Input.set_mouse_mode(2)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if event is InputEventMouseMotion:
		springArmPivot.rotate_y(-event.relative.x*mouseSens)
		springArm.rotate_x(deg_to_rad(-event.relative.y*mouseSens * 90))
		springArm.rotation.x = clamp(springArm.rotation.x, -PI/4,0.45)
		

func _process(delta: float) -> void:
	var leap:float = 0
	pass

func _physics_process(delta: float) -> void:
	#get distance from ground
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	
		
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	# adjust direction to where cam is facing
	direction = direction.rotated(Vector3.UP, springArmPivot.rotation.y)
	
	if direction:
		# added lerp to velocity for animation 
		velocity.x = lerp(velocity.x,direction.x * SPEED,lerpVal)
		velocity.z = lerp(velocity.z,direction.z * SPEED,lerpVal)
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-velocity.x,-velocity.z), lerpVal)
	else:
		velocity.x = lerp(velocity.x,0 * SPEED,lerpVal)
		velocity.z = lerp(velocity.z,0 * SPEED,lerpVal)
	
	# only x and z run speed to affect walk animation 
	var runSpeed = (velocity* Vector3(1,0,1)).length() 
	
	animTree.set("parameters/BlendSpace1D/blend_position", runSpeed/SPEED)
	animTree.set
	
	move_and_slide()


