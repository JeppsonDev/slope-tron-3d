extends Control

var __is_showing:bool = false;

export(Material) var mat;

func toggle_menu():
	if(__is_showing):
		hide();
		__is_showing = false;
	else:
		show();
		__is_showing = true;


func _on_RedSlider_value_changed(value):
	mat.albedo_color.r = float(value)/float(255);
	mat.emission.r = float(value)/float(255);


func _on_GreenSlider_value_changed(value):
	mat.albedo_color.g = float(value)/float(255);
	mat.emission.g = float(value)/float(255);


func _on_BlueSlider_value_changed(value):
	mat.albedo_color.b = float(value)/float(255);
	mat.emission.b = float(value)/float(255);
