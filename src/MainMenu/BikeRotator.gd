extends Spatial

var reset_rotation:bool = false;
var driveaway:bool = false;
var speed:float = 100;
var acceleration:float = 0;

func _process(delta)->void:
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
	$DriveAwayTimer.start();

func _on_DriveAwayTimer_timeout():
	driveaway = true;
	$StartNextSceneTimer.start();
