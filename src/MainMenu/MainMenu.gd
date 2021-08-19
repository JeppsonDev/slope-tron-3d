extends Scene

func _ready()->void:
	$UI/SceneTransition.animation_player.connect("animation_finished", self, "__on_animation_finished");

	var r = Application.get_node("SaveGame").get_value("bike_emission_r");
	var g = Application.get_node("SaveGame").get_value("bike_emission_g");
	var b = Application.get_node("SaveGame").get_value("bike_emission_b");
	
	$UI/CustomizeBike/Panel/VBoxContainer/HBoxContainer/RedSlider.value = r*255;
	$UI/CustomizeBike/Panel/VBoxContainer/HBoxContainer2/GreenSlider.value = g*255;
	$UI/CustomizeBike/Panel/VBoxContainer/HBoxContainer3/BlueSlider.value = b*255;
	

func _on_StartNextSceneTimer_timeout():
	$UI/SceneTransition.transition_out();
	
func __on_animation_finished(anim)->void:
	change_scene_data(1, {trans_in=true});
