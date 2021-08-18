extends Scene

func _ready()->void:
	$UI/SceneTransition.animation_player.connect("animation_finished", self, "__on_animation_finished");

func _on_StartNextSceneTimer_timeout():
	$UI/SceneTransition.transition_out();
	
func __on_animation_finished(anim)->void:
	change_scene(1);
