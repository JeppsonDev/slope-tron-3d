extends Spatial

export(NodePath) var __camera_path:NodePath;

onready var __camera:Spatial = get_node(__camera_path);

var __camera_pos:Vector3 = Vector3();
var __camera_rot:Vector3 = Vector3();

var __mouse_delta:Vector2 = Vector2();

func _ready()->void:
	assert(__camera);

func _process(delta)->void:
	
	if(Input.is_action_just_pressed("debug")):
		if(!Application.debug):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
			
		Application.debug = !Application.debug;
		__save_previous_values();
	
	if(!Application.debug):
		return;
	
	var aim = __camera.global_transform.basis
	
	if(Input.is_action_just_pressed("up")):
		__camera.global_transform.origin = __camera.global_transform.origin - aim.z;
	if(Input.is_action_just_pressed("down")):
		__camera.global_transform.origin = __camera.global_transform.origin + aim.z;
	if(Input.is_action_just_pressed("left")):
		__camera.global_transform.origin = __camera.global_transform.origin - aim.x;
	if(Input.is_action_just_pressed("right")):
		__camera.global_transform.origin = __camera.global_transform.origin + aim.x;
		
		
	__camera.rotation_degrees.x -= __mouse_delta.y * 10 * delta;
	__camera.rotation_degrees.x = clamp(__camera.rotation_degrees.x, -90, 90);
	__camera.rotation_degrees.y -= __mouse_delta.x * 10 * delta;
	
	__mouse_delta = Vector2();
		
func _input(event:InputEvent)->void:
	if(event is InputEventMouseMotion):
		__mouse_delta = event.relative;
		
func __save_previous_values()->void:
	__camera_pos = __camera.global_transform.origin;
	__camera_rot = __camera.rotation_degrees;
