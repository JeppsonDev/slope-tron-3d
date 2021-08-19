extends Label

func _ready()->void:
	var hiscore:String = str(Application.get_node("SaveGame").get_value("highscore"));
	text = "Highscore: " + hiscore; 
