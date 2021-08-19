extends Node
class_name Scene

# Signals
signal change_scene(scene_id, data);

# Public Variables
var scene_id:int = 0; # This is initialized in SceneManager upon scene start
var scene_data:Dictionary setget set_scene_data, get_scene_data;

func scene_ready()->void:
	pass

# Public Functions
func change_scene(scene_id:int)->void:
	change_scene_data(scene_id, {});
	
func change_scene_data(scene_id:int, data:Dictionary)->void:
	emit_signal("change_scene", scene_id, data);
	
func restart()->void:
	change_scene(scene_id);
	
func set_scene_data(data)->void:
	scene_data = data;

func get_scene_data()->Dictionary:
	return scene_data;
