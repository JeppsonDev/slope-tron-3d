extends Node

onready var scene_manager:SceneManager = get_node("SceneManager");
onready var save_game:SaveGame = get_node("SaveGame");
onready var main_music:AudioStreamPlayer = get_node("MainMusic");

var paused:bool = false;
var debug:bool = false;

func _ready()->void:
	main_music.play();
