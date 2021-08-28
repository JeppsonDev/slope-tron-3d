extends Spatial
class_name ThirdPersonFollowCamera

# Export Private
export var __following_path:NodePath;

# Onready Private
onready var __following:Spatial = get_node(__following_path);
onready var __camera:Camera = get_node("Camera");
onready var __warpdrivevfx:Spatial = get_node("Camera/WarpDriveVfx");

var __fov = false;

func _ready()->void:
	assert(__following);
	__warpdrivevfx.stop();
	
func _process(delta)->void:
	if(Application.debug):
		return;
	
	global_transform.origin = __following.global_transform.origin;
	rotation_degrees.y = __following.rotation_degrees.y;
	rotation_degrees.x = lerp(rotation_degrees.x, __following.rotation_degrees.x, 4 * delta)
	
	if(__fov):
		__camera.fov = lerp(__camera.fov, 90, 2*delta);
	else:
		if(__camera.fov < 70.9):
			__camera.fov = 70;
		__camera.fov = lerp(__camera.fov, 70, 2*delta);
	
func start_warpdrive()->void:
	__warpdrivevfx.start();
	__fov = true;
	$FovTimer.start();

func _on_FovTimer_timeout():
	__fov = false;
