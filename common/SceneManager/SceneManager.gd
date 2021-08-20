extends Node
class_name SceneManager

export(Array, String) var __scene_paths;

var current_scene:Scene = null;

var main_menu_scene = preload("res://src/MainMenu/MainMenu.tscn");
var game_scene = preload("res://src/GameScene/GameScene.tscn");

func _ready()->void:
	__on_scene_change_scene(0, {trans_in=false});
	
func __load_scene(path:String, scene_data:Dictionary)->Scene:
	#var scene:PackedScene = load(path);
	var scene:PackedScene = null;
	if(path == "res://src/MainMenu/MainMenu.tscn"):
		scene = main_menu_scene;
	if(path == "res://src/GameScene/GameScene.tscn"):
		scene = game_scene;
	
	var instance:Scene = scene.instance();
	instance.connect("change_scene", self, "__on_scene_change_scene");
	add_child(instance);
	return instance;
	
func __on_scene_change_scene(scene_id:int, scene_data:Dictionary)->void:
	if(current_scene != null):
		current_scene.queue_free();
	
	current_scene = __load_scene(__scene_paths[scene_id], scene_data);
	current_scene.scene_id = scene_id;
	current_scene.scene_data = scene_data;
	current_scene.scene_ready();
