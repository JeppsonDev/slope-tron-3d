tool
extends Spatial
class_name PlatformBase

# Signals
signal passed_end_area();

# Exports public
export var start_position:Vector3;
export var end_position:Vector3;

# Onready Public
onready var floor_enter_area:Area = get_node("FloorEnterArea");
onready var restart_zone:Area = get_node("RestartZone");
onready var score_zone:Area = get_node("ScoreZone");

func _ready()->void:
	assert(floor_enter_area);
	assert(restart_zone);

func __on_player_entered_scorezone(body):
	emit_signal("passed_end_area");
