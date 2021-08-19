extends Scene
class_name GameScene

# Public onready
onready var ui = get_node("UI");
onready var game_world:GameWorld = get_node("GameWorld");

func scene_ready()->void:
	if(scene_data.trans_in):
		ui.trans_in();
	else:
		$UI/SceneTransition.queue_free();
