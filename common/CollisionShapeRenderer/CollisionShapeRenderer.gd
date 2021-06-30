tool
extends MeshInstance
class_name CollisionShapeRenderer

export(Resource) var __collision_shape

func _ready()->void:
	var collision_shape:CollisionShape = __collision_shape as CollisionShape;
	
	scale.x = __collision_shape.extents.x;
	scale.y = __collision_shape.extents.y;
	scale.z = __collision_shape.extents.z;
	
