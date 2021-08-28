extends KinematicBody
class_name Bike

# Signals
signal speedup();

# Constants
const LEAN:float = 2.5;
const ACCELERATION:float = 2.0;
const DEACCELERATION:float = 0.5;
const STEER_SPEED:float = 0.065;
const FALLDOWN:float = 5.0;
const NORM_SPEED:float = 1000.0
const SPEED_INCREASE:float = 4.5;
const SPEEDBOOST_DECREASE:float = 7.5;

# Private Exports
export(Material) var __mat;

# Private Onready
onready var __scifi_bike:Spatial = get_node("scifi_bike");
onready var __frontwheelraycast:RayCast = get_node("FrontWheelRaycast");
onready var __backwheelraycast:RayCast = get_node("BackWheelRayCast");
onready var __floordetector:RayCast = get_node("FloorDetector");
onready var __interaction_hitbox:Area = get_node("InteractionHitbox");
onready var __speedboost:AudioStreamPlayer = get_node("SpeedBoost");
onready var __tiresqueal:AudioStreamPlayer = get_node("TireSqueal");
onready var __thump:AudioStreamPlayer = get_node("Thump");
onready var __trail3d:Trail3D = get_node("scifi_bike/BikeShell/Trail3D");

# Private Fields
var __direction:Vector3 = Vector3();
var __gravity:Vector3 = Vector3();
var __gravity_acceleration:float = 0;
var __acceleration:float = 0;
var __max_acceleration:float = 1;
var __steer:float = 0;
var __in_air:bool = false;
var __has_started:bool = false;

var __left:bool = false;

# Public Fields
var speed:float = 1000.0;
var max_speed:float = 2500.0;

func __align_with_y(xform:Transform, new_y:Vector3)->Transform:
	xform.basis.y = new_y;
	xform.basis.x = -xform.basis.z.cross(new_y);
	xform.basis = xform.basis.orthonormalized();
	return xform;

func __on_area_enter(area:Area)->void:
	if(area.is_in_group("speedboost")):
		max_speed += 200;
		speed += 1000;
		emit_signal("speedup")
		__speedboost.play();
		__trail3d.animate();
		

func _input(event):
	if event is InputEventMouse and event.is_pressed():
		__has_started = true;
	
	if event is InputEventKey and event.pressed:
		__has_started = true;

func _ready()->void:
	assert(__scifi_bike);
	assert(__frontwheelraycast);
	assert(__backwheelraycast);
	assert(__floordetector);
	assert(__interaction_hitbox);
	assert(__trail3d);
	
	__interaction_hitbox.connect("area_entered", self, "__on_area_enter");
	
	__mat.albedo_color.r = Application.save_game.get_value("bike_albedo_r");
	__mat.albedo_color.g = Application.save_game.get_value("bike_albedo_g");
	__mat.albedo_color.b = Application.save_game.get_value("bike_albedo_b");
	
	__mat.emission.r = Application.save_game.get_value("bike_emission_r");
	__mat.emission.g = Application.save_game.get_value("bike_emission_g");
	__mat.emission.b = Application.save_game.get_value("bike_emission_b");

func _physics_process(delta)->void:
	if(Application.paused or Application.debug):
		return;
		
	if(!__has_started):
		return;
		
	__direction = __direction.normalized();
	__gravity = Vector3(__gravity.x, -200*__gravity_acceleration, __gravity.z);
			
	var should_accelerate:bool = false;

	__direction += -global_transform.basis.z;
	should_accelerate = true;
	
	if(Input.is_action_pressed("down")):
		if(should_accelerate):
			__tiresqueal.play();
		#__direction += global_transform.basis.z;
		__acceleration -= 0.1 * delta;
		should_accelerate = false;
	else:
		__tiresqueal.stop();
		
	if(should_accelerate):
		if(__acceleration < __max_acceleration and !__in_air):
			__acceleration += ACCELERATION * delta;
			
		if((__max_acceleration-__acceleration)<-0.05):
			__acceleration -= DEACCELERATION * delta;
			
		if(__acceleration > __max_acceleration):
			if(speed < max_speed):
				speed += SPEED_INCREASE;
			else:
				speed -= SPEEDBOOST_DECREASE;
				
#		if(__in_air):
#			if(__acceleration > 0.7):
#				__acceleration -= 0.4 * delta;
#			else:
#				__acceleration = 0.7;
#			if(__speed > NORM_SPEED):
#				__speed -= SPEED_INCREASE;
	else:
		if(__acceleration > 0):
			__acceleration -= 0.25 * delta;
		else:
			__acceleration = 0;
		if(speed > NORM_SPEED):
			speed -= SPEED_INCREASE;
		
	if(Input.is_action_pressed("right")):
			
		__left = false;
		
		if(__steer > -1):
			__steer -= STEER_SPEED;
			
		if(__steer >= -1 and __steer < -0.5):
			__max_acceleration = 0.5;
			
		if(rotation_degrees.z > -31):
			rotation_degrees.z -= LEAN
			
	else:
		__max_acceleration = 1;
		
	if(Input.is_action_pressed("left")):
			
		__left = true;
		
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
		if(__in_air and __gravity_acceleration >= 0.5):
			__thump.play();
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
	move_and_slide_with_snap(__direction * __acceleration * speed * delta, Vector3.DOWN*2, Vector3.UP, true);
	__scifi_bike.spin_wheel_front(__acceleration*speed/100);
	__scifi_bike.spin_wheel_back(__acceleration*speed/100);
