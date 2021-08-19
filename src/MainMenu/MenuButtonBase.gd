extends TextureButton
class_name MenuButtonBase

var is_pressed:bool=false;

func _ready()->void:
	connect("button_down", self, "__on_button_down");
	connect("button_up", self, "__on_button_up");

func _process(delta)->void:
	
	if(is_pressed):
		return;
	
	if(is_hovered()):
		rect_scale.x = 1.1;
		rect_scale.y = 1.1;
	else:
		rect_scale.x = 1;
		rect_scale.y = 1;

func __on_button_down()->void:
	rect_scale.x = 1.25;
	rect_scale.y = 1.25;
	is_pressed = true;
	$Select.play();
	
func __on_button_up()->void:
	rect_scale.x = 1;
	rect_scale.y = 1;
	is_pressed = false;
