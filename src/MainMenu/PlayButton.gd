extends MenuButtonBase

func _process(delta)->void:
	
	if(is_pressed):
		Application.main_music.pitch_scale = lerp(Application.main_music.pitch_scale, 1.0, 5*delta);
		return;
	
	if(is_hovered()):
		rect_scale.x = 1.1;
		rect_scale.y = 1.1;
	else:
		rect_scale.x = 1;
		rect_scale.y = 1;

func __on_button_down()->void:
	.__on_button_down();
	Application.main_music.stop();
	Application.main_music.play(0);
	Application.main_music.pitch_scale = 0.1;

func __on_button_up()->void:
	.__on_button_up()
	is_pressed = true;
