extends Spatial
class_name SpeedBoost

onready var __cube:MeshInstance = get_node("Cube");
onready var __cubemat:Material = __cube.get_surface_material(0);

func _process(delta):
	__cube.get_surface_material(0).uv1_offset.y -= 0.08 * delta;
