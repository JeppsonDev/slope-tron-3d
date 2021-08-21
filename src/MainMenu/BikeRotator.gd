extends Spatial

var reset_rotation:bool = false;
var driveaway:bool = false;
var speed:float = 100;
var acceleration:float = 0;

var dir1:int = 0;
var dir2:int = 1;
var dir3:int = 0;

export(Material) var __mat;

func _ready()->void:
	__mat.albedo_color.r = Application.get_node("SaveGame").get_value("bike_albedo_r");
	__mat.albedo_color.g = Application.get_node("SaveGame").get_value("bike_albedo_g");
	__mat.albedo_color.b = Application.get_node("SaveGame").get_value("bike_albedo_b");
	
	__mat.emission.r = Application.get_node("SaveGame").get_value("bike_emission_r");
	__mat.emission.g = Application.get_node("SaveGame").get_value("bike_emission_g");
	__mat.emission.b = Application.get_node("SaveGame").get_value("bike_emission_b");
	
	__mat.albedo_color.r = 1
	__mat.albedo_color.g = 0.5
	__mat.albedo_color.b = 1
	
	
	__mat.emission.r = 1
	__mat.emission.g = 0.5
	__mat.emission.b = 1
	
	
	pass

func _process(delta)->void:

# ALL OF THIS IS FOR TWITTER
	
#	if(__mat.albedo_color.r <= 0.01):
#		dir1 = 1;
#	if(__mat.albedo_color.r >= 0.98):
#		dir1 = 0;
#
#	__mat.albedo_color.r = lerp(__mat.albedo_color.r, dir1, delta*0.5);
#	__mat.emission.r = lerp(__mat.albedo_color.r, dir1, delta*0.5);
#
#	if(__mat.albedo_color.g <= 0.01):
#		dir2 = 1;
#	if(__mat.albedo_color.g >= 0.98):
#		dir2 = 0;
#
#	__mat.albedo_color.g = lerp(__mat.albedo_color.g, dir2, delta*1);
#	__mat.emission.g = lerp(__mat.albedo_color.g, dir2, delta*1);
#
#	if(__mat.albedo_color.b <= 0.01):
#		dir3 = 1;
#	if(__mat.albedo_color.b >= 0.98):
#		dir3 = 0;
#
#	__mat.albedo_color.b = lerp(__mat.albedo_color.b, dir3, delta*0.5);
#	__mat.emission.b = lerp(__mat.albedo_color.b, dir3, delta*0.5);
#
#	print(__mat.albedo_color.g)
	
	if (!reset_rotation):
		rotate_y(1*delta);
	else:
		rotation_degrees.y = lerp(rotation_degrees.y, 0, 10*delta);
		
	if(driveaway):
		acceleration = acceleration + 0.5*delta;
		if(acceleration >= 1):
			acceleration = 1;
		global_transform.origin.z = global_transform.origin.z - (speed*acceleration*delta);

func _on_TextureButton_pressed():
	reset_rotation = true;
	Application.save_game.set_value("bike_albedo_r", __mat.albedo_color.r)
	Application.save_game.set_value("bike_albedo_g", __mat.albedo_color.g)
	Application.save_game.set_value("bike_albedo_b", __mat.albedo_color.b)
	
	Application.save_game.set_value("bike_emission_r", __mat.emission.r)
	Application.save_game.set_value("bike_emission_g", __mat.emission.g)
	Application.save_game.set_value("bike_emission_b", __mat.emission.b)
	
	Application.save_game.set_value("bus_master", AudioServer.get_bus_volume_db(0));
	Application.save_game.set_value("bus_sfx", AudioServer.get_bus_volume_db(1));
	Application.save_game.set_value("bus_music", AudioServer.get_bus_volume_db(2));
	
	Application.save_game.save_game();
	
	$DriveAwayTimer.start();

func _on_DriveAwayTimer_timeout():
	driveaway = true;
	$StartNextSceneTimer.start();
