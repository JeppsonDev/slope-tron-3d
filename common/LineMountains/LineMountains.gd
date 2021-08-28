extends ImmediateGeometry
class_name LineMountains

export(Gradient) var __gradient;

var a = 0.1;

func _ready():
	material_override.emission = __gradient.interpolate((float(0)/float(100)));
	material_override.emission_energy = 0.35
	get_parent().connect("score_increased", self, "__on_score_increased");
	
func __on_score_increased(score)->void:
	material_override.emission = __gradient.interpolate((float(score)/float(100)));
	material_override.emission_energy = 0.35

func _process(delta):
	
	global_transform.origin.x += 10 * delta;
	
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
