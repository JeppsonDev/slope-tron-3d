tool
extends Spatial
class_name PlatformBase

# Exports public
export var start_position:Vector3;
export var end_position:Vector3;

# Onready Public
onready var floor_enter_area:Area = get_node("FloorEnterArea");

func _ready()->void:
	assert(floor_enter_area);
