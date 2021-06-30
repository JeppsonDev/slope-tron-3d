extends KinematicBody
class_name Bike

# Constants
const LEAN:float = 1.75;
const ACCELERATION:float = 2.0;
const DEACCELERATION:float = 0.5;
const STEER_SPEED:float = 0.05;
const FALLDOWN:float = 5.0;
const NORM_SPEED:float = 1000.0
const SPEED_INCREASE:float = 2.5;

# Private Onready
onready var __scifi_bike:Spatial = get_node("scifi_bike");
onready var __frontwheelraycast:RayCast = get_node("FrontWheelRaycast");
onready var __backwheelraycast:RayCast = get_node("BackWheelRayCast");
onready var __floordetector:RayCast = get_node("FloorDetector");
onready var __interaction_hitbox:Area = get_node("InteractionHitbox");

# Private Fields
var __direction:Vector3 = Vector3();
var __gravity:Vector3 = Vector3();
var __gravity_acceleration:float = 0;
var __acceleration:float = 0;
var __max_acceleration:float = 1;
var __speed:float = 1000.0;
var __max_speed:float = 2500.0;
var __steer:float = 0;
var __in_air:bool = false;
var __has_started:bool = false;

func __align_with_y(xform:Transform, new_y:Vector3)->Transform:
	xform.basis.y = new_y;
	xform.basis.x = -xform.basis.z.cross(new_y);
	xform.basis = xform.basis.orthonormalized();
	return xform;

func __on_area_enter(area:Area)->void:
	if(area.is_in_group("speedboost")):
		__max_speed += 1000;
		__speed += 500;

func _ready()->void:
	assert(__scifi_bike);
	assert(__frontwheelraycast);
	assert(__backwheelraycast);
	assert(__floordetector);
	assert(__interaction_hitbox);
	
	__interaction_hitbox.connect("area_entered", self, "__on_area_enter");

func _process(delta)->void:
	if(Input.is_action_pressed("up")):
		__has_started = true;

func _physics_process(delta)->void:
	if(!__has_started):
		return;
		
	__direction = __direction.normalized();
	__gravity = Vector3(__gravity.x, -200*__gravity_acceleration, __gravity.z);
			
	var should_accelerate:bool = false;

	__direction += -global_transform.basis.z;
	should_accelerate = true;
	
	if(Input.is_action_pressed("down")):
		#__direction += global_transform.basis.z;
		__acceleration -= 0.01 * delta;
		should_accelerate = false;
		
	if(should_accelerate):
		if(__acceleration < __max_acceleration and !__in_air):
			__acceleration += ACCELERATION * delta;
			
		if((__max_acceleration-__acceleration)<-0.05):
			__acceleration -= DEACCELERATION * delta;
			
		if(__acceleration > __max_acceleration):
			if(__speed < __max_speed):
				__speed += SPEED_INCREASE;
				
		if(__in_air):
			if(__acceleration > 0.7):
				__acceleration -= 0.4 * delta;
			else:
				__acceleration = 0.7;
			if(__speed > NORM_SPEED):
				__speed -= SPEED_INCREASE;
	else:
		if(__acceleration > 0):
			__acceleration -= 0.25 * delta;
		else:
			__acceleration = 0;
		if(__speed > NORM_SPEED):
			__speed -= SPEED_INCREASE;
		
	if(Input.is_action_pressed("right")):
		if(__steer > -1):
			__steer -= STEER_SPEED;
			
		if(__steer >= -1 and __steer < -0.5):
			__max_acceleration = 0.5;
			
		if(rotation_degrees.z > -31):
			rotation_degrees.z -= LEAN
			
	else:
		__max_acceleration = 1;
		
	if(Input.is_action_pressed("left")):
		if(__steer < 1):
			__steer += STEER_SPEED;
			
		if(__steer <= 1 and __steer > 0.5):
			__max_acceleration = 0.5;
			
		if(rotation_degrees.z < 31):
			rotation_degrees.z += LEAN
	else:
		__max_acceleration = 1;
			
	if(should_accelerate):
		rotation_degrees.y += (2 * __steer)/(__acceleration+1);
		
	if(!Input.is_action_pressed("right") and !Input.is_action_pressed("left")):
		if(__steer > -STEER_SPEED and __steer < STEER_SPEED):
			__steer = 0;
		elif(__steer > 0):
			__steer -= STEER_SPEED;
		elif(__steer < 0):
			__steer += STEER_SPEED;
			
		if(rotation_degrees.z > -LEAN and rotation_degrees.z < LEAN):
			rotation_degrees.z = 0;
		elif(rotation_degrees.z > 0):
			rotation_degrees.z -= LEAN;
		elif(rotation_degrees.z < 0):
			rotation_degrees.z += LEAN;
			
	if(!__floordetector.is_colliding()):
		__in_air = true;
		
		if(rotation_degrees.x > -11.483):
			rotation_degrees.x -= LEAN/4;

		if(__gravity_acceleration < 1):
			__gravity_acceleration += 0.01;
	else:
		__gravity_acceleration = 0;
		__in_air = false;
		
	if(__frontwheelraycast.is_colliding() or __backwheelraycast.is_colliding()):
		var n1 = __frontwheelraycast.get_collision_normal() if __frontwheelraycast.is_colliding() else Vector3.UP
		var n2 = __backwheelraycast.get_collision_normal() if __backwheelraycast.is_colliding() else Vector3.UP
		var normal:Vector3 = ((n2 + n1) / 2.0).normalized()
		var transform:Transform = __align_with_y(global_transform, normal);
		global_transform = global_transform.interpolate_with(transform, 0.15);
		
		if(__frontwheelraycast.get_collider() != null):
			var slope:Spatial = __frontwheelraycast.get_collider().get_owner();
			if(slope.rotation_degrees.x >= 1 or slope.rotation_degrees.x <= -1):
				# We're sloping
				__gravity += (-global_transform.basis.z.normalized() * -slope.rotation_degrees.x)/360;
				
	move_and_slide_with_snap(__gravity, Vector3.DOWN*2, Vector3.UP, true);
	move_and_slide_with_snap(__direction * __acceleration * __speed * delta, Vector3.DOWN*2, Vector3.UP, true);
	__scifi_bike.spin_wheel_front(__acceleration*20);
	__scifi_bike.spin_wheel_back(__acceleration*20);
