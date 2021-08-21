extends "res://src/GameScene/DeathScreen.gd"

func _ready()->void:
	rect_scale.x = 0;
	rect_scale.y = 0;
	hide();

func _process(delta):
	._process(delta);
	
	if(Input.is_action_just_pressed("pause") and !Application.paused):
		Application.paused = true;
		get_node("AnimationPlayer").play("popup");
		show();
		
		return;
	if(Input.is_action_just_pressed("pause") and Application.paused):
		Application.paused = false;
		hide();
		rect_scale.x = 0;
		rect_scale.y = 0;
		return;

func _on_Play_pressed():
	rect_scale.x = 0;
	rect_scale.y = 0;
	Application.paused = false;
	hide();
