extends Spatial
class_name ThirdPersonFollowCamera

# Export Private
export var __following_path:NodePath;

# Onready Private
onready var __following:Spatial = get_node(__following_path);
onready var __camera:Camera = get_node("Camera");
onready var __warpdrivevfx:Spatial = get_node("Camera/WarpDriveVfx");

func _ready()->void:
	assert(__following);
	__warpdrivevfx.stop();
	
func _process(delta)->void:
	if(Application.debug):
		return;
	
	global_transform.origin = __following.global_transform.origin;
	rotation_degrees.y = __following.rotation_degrees.y;
	rotation_degrees.x = lerp(rotation_degrees.x, __following.rotation_degrees.x, 4 * delta)
	
func start_warpdrive()->void:
	__warpdrivevfx.start();
