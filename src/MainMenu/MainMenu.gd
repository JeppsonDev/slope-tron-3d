extends Scene

func scene_ready()->void:
	scene_data.trans_in=true;
	if(scene_data.trans_in):
		$UI/SceneTransition.show();
		$UI/SceneTransition.transition_in();
	pass
	
	Application.get_node("MainMusic").pitch_scale = 0.6;

func _ready()->void:
	$UI/SceneTransition.animation_player.connect("animation_finished", self, "__on_animation_finished");

	var r = Application.get_node("SaveGame").get_value("bike_emission_r");
	var g = Application.get_node("SaveGame").get_value("bike_emission_g");
	var b = Application.get_node("SaveGame").get_value("bike_emission_b");
	
	$UI/CustomizeBike/Panel/VBoxContainer/HBoxContainer/RedSlider.value = r*255;
	$UI/CustomizeBike/Panel/VBoxContainer/HBoxContainer2/GreenSlider.value = g*255;
	$UI/CustomizeBike/Panel/VBoxContainer/HBoxContainer3/BlueSlider.value = b*255;
	

func _on_StartNextSceneTimer_timeout():
	$UI/SceneTransition.show();
	$UI/SceneTransition.transition_out();
	
func __on_animation_finished(anim)->void:
	if(scene_data.trans_in):
		scene_data.trans_in = false;
		return;
	change_scene_data(1, {trans_in=true});
