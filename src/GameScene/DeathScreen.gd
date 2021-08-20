extends Control

var start = false;

func init(score, highscore):
	start = true;
	$AnimationPlayer.play("popup")
	$Panel2/Label4.text = "Score: " + str(score);
	$Panel2/Label5.text = "Highscore: " + str(highscore);

func _process(delta):
	if(start):
		Application.main_music.pitch_scale = lerp(Application.main_music.pitch_scale, 0.6, 5*delta);
