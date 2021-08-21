tool
extends ImmediateGeometry
class_name LineMountains

func _process(delta):
	var goaly = get_parent().get_node("Bike").global_transform.origin.y + 0 - 322.55 - 250;
	var goalz = get_parent().get_node("Bike").global_transform.origin.z + 0 - 326.092 - 2000+1000;
	global_transform.origin.y = lerp(global_transform.origin.y, goaly, 5*delta);
	global_transform.origin.z = lerp(global_transform.origin.z, goalz, 5*delta);
	clear();
	for i in 150:
		drawline(Vector3(i*2,0,0), Vector3(i*2,0,200));
		drawline(Vector3(-i*2,0,0), Vector3(-i*2,0,200));
		
#I'm assuming we're in an ImmediateGeometry node already
func drawline(a:Vector3,b:Vector3):
	begin(Mesh.PRIMITIVE_LINE_STRIP)
	set_color(Color.white);
	add_vertex(a)
	add_vertex(b)
	end()
