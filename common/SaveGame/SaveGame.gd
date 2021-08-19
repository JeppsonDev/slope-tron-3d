extends Node
class_name SaveGame

signal loaded();

const PATH = "user://data.json";

var __data:Dictionary = {
	highscore=0,
	bike_albedo_r=1,
	bike_albedo_g=1,
	bike_albedo_b=1,
	bike_emission_r=1,
	bike_emission_g=1,
	bike_emission_b=1
};

func _ready()->void:
	load_game();

func save_game()->void:
	var file = File.new()
	file.open(PATH, File.WRITE)
	file.store_line(to_json(__data))
	file.close()
	
func load_game()->void:
	var file = File.new()
	if file.file_exists(PATH):
		file.open(PATH, File.READ)
		var data = {}
		var text = file.get_as_text()
		data = parse_json(text)
		__data = data
		file.close()
		
	emit_signal("loaded");

func set_value(key, value)->void:
	__data[key] = value;
	
func get_value(key):
	return __data[key];
