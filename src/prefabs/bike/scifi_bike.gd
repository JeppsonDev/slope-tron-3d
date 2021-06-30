extends Spatial

onready var __wheel_back = get_node("WheelBack")
onready var __wheel_front = get_node("WheelFront");

func _ready()->void:
	assert(__wheel_back);
	assert(__wheel_front);

func spin_wheel_back(speed:float)->void:
	__wheel_back.rotation_degrees.x += speed;
	
func spin_wheel_front(speed:float)->void:
	__wheel_front.rotation_degrees.x += speed;
