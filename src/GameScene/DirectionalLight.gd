extends DirectionalLight

export(Gradient) var __gradient;

func _ready():
	get_parent().connect("score_increased", self, "__on_score_increased");
	
func __on_score_increased(score)->void:
	print("waaat");
	light_color = __gradient.interpolate((float(score)/float(100)));
