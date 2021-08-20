extends "res://src/MainMenu/CustomizeBike.gd"

func _ready()->void:
	var m = Application.get_node("SaveGame").get_value("bus_master");
	var sfx = Application.get_node("SaveGame").get_value("bus_sfx");
	var music = Application.get_node("SaveGame").get_value("bus_music");
	
	AudioServer.set_bus_volume_db(0, m);
	AudioServer.set_bus_volume_db(1, sfx);
	AudioServer.set_bus_volume_db(2, music);
	
	$Panel/VBoxContainer/HBoxContainer/RedSlider.value = m+71;
	$Panel/VBoxContainer/HBoxContainer2/GreenSlider.value = music+71;
	$Panel/VBoxContainer/HBoxContainer3/BlueSlider.value = sfx+71;

func _on_RedSlider_value_changed(value):
	AudioServer.set_bus_volume_db(0, value-71);

func _on_GreenSlider_value_changed(value):
	AudioServer.set_bus_volume_db(2, value-71);
	
func _on_BlueSlider_value_changed(value):
	AudioServer.set_bus_volume_db(1, value-71); 
