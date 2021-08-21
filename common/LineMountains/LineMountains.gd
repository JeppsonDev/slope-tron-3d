tool
extends ImmediateGeometry
class_name LineMountains

func _process(delta):
	global_transform.origin.y = get_parent().get_node("Bike").global_transform.origin.y + 0 - 322.55 - 250;
	global_transform.origin.z = get_parent().get_node("Bike").global_transform.origin.z + 0 - 326.092 - 2000+1000;
	clear();
	for i in 150:
		drawline(Vector3(i*2,0,0), Vector3(i*2,0,100));
		drawline(Vector3(-i*2,0,0), Vector3(-i*2,0,100));
		
#I'm assuming we're in an ImmediateGeometry node already
func drawline(a:Vector3,b:Vector3):
	begin(Mesh.PRIMITIVE_LINE_STRIP)
	set_color(Color.white);
	add_vertex(a)
	add_vertex(b)
	end()
