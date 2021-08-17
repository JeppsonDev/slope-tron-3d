extends Spatial

onready var __one:Vector3 = get_node("1").global_transform.origin;
onready var __two:Vector3 = get_node("2").global_transform.origin;

var __to_one:bool = true;

func _process(delta):
	if(__to_one):
		var dir = (__one - global_transform.origin).normalized();
		global_transform.origin = global_transform.origin + dir * 50 * delta;
		if(global_transform.origin.distance_to(__one) < 1):
			__to_one = false;
	else:
		var dir = (__two - global_transform.origin).normalized();
		global_transform.origin = global_transform.origin + dir * 50 * delta;
		if(global_transform.origin.distance_to(__two) < 1):
			__to_one = true;
