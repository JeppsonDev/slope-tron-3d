extends Spatial
class_name ThirdPersonFollowCamera

# Export Private
export var __following_path:NodePath;

# Onready Private
onready var __following:Spatial = get_node(__following_path);
onready var __camera:Camera = get_node("Camera");

func _ready()->void:
	assert(__following);
	
func _process(delta)->void:
	global_transform.origin = __following.global_transform.origin;
	rotation_degrees.y = __following.rotation_degrees.y;
