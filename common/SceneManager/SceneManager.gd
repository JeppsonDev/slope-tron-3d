extends Node
class_name SceneManager

export(Array, String) var __scene_paths;

var current_scene:Scene = null;

func _ready()->void:
	__on_scene_change_scene(0, {});

func __load_scene(path:String, scene_data:Dictionary)->Scene:
	var scene:PackedScene = load(path);
	var instance:Scene = scene.instance();
	instance.connect("change_scene", self, "__on_scene_change_scene");
	add_child(instance);
	return instance;
	
func __on_scene_change_scene(scene_id:int, scene_data:Dictionary)->void:
	if(current_scene != null):
		current_scene.queue_free();
	
	current_scene = __load_scene(__scene_paths[scene_id], scene_data);
	current_scene.scene_id = scene_id;
