extends Control
class_name UI

onready var score_label:Label = get_node("Score");

onready var __speed_label:Label = get_node("VBoxContainer/SpeedLabel");
onready var __max_speed_label:Label = get_node("VBoxContainer/MaxSpeedLabel");
onready var __acceleration_label:Label = get_node("VBoxContainer/Acceleration")
onready var __scene_transition = get_node("SceneTransition");

func trans_in()->void:
	__scene_transition.transition_in();

func _process(delta)->void:
	__speed_label.text = "Speed: " + str(get_owner().game_world.bike.speed);
	__max_speed_label.text = "Max Speed: " + str(get_owner().game_world.bike.max_speed);
	__acceleration_label.text = "Acceleration: " + str(get_owner().game_world.bike.__acceleration);
