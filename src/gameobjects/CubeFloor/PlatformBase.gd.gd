tool
extends Spatial
class_name PlatformBase

# Signals
signal passed_end_area();

# Exports public
export var start_position:Vector3;
export var end_position:Vector3;

# Onready Private
onready var __restart_zone:Area = get_node("RestartZone");

# Onready Public
onready var floor_enter_area:Area = get_node("FloorEnterArea");

func _ready()->void:
	assert(floor_enter_area);
	assert(__restart_zone);
	
	__restart_zone.connect("body_entered", self, "__on_player_entered_restartzone");
	
func __on_player_entered_scorezone(body):
	emit_signal("passed_end_area");
	
func __on_player_entered_restartzone(body):
	get_tree().root.get_node("Application").get_node("SceneManager").current_scene.restart();
