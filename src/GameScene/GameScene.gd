extends Scene
class_name GameScene

# Public onready
onready var ui = get_node("UI");
onready var game_world:GameWorld = get_node("GameWorld");

var start=false;

func scene_ready()->void:
	start = true;
	$UI/SceneTransition.animation_player.connect("animation_finished", self, "__on_animation_finished");
	if(scene_data.trans_in):
		$UI/SceneTransition.show();
		ui.trans_in();
	else:
		$UI/SceneTransition.hide();

func _process(delta):
	if(start):
		Application.main_music.pitch_scale = lerp(Application.main_music.pitch_scale, 1.0, 5*delta);


func _on_GoBack_pressed():
	$UI/SceneTransition.show();
	$UI/SceneTransition.transition_out();

func _on_Restart_pressed():
	change_scene_data(1, {trans_in=false});

func __on_animation_finished(anim)->void:
	if(scene_data.trans_in):
		scene_data.trans_in = false;
		return;
	change_scene_data(0,{trans_in=true});
