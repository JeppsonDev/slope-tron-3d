extends Button

export(String) var __link;

func _ready()->void:
	connect("pressed", self, "__on_button_pressed");
	
func __on_button_pressed()->void:
	OS.shell_open(__link);
	pass
