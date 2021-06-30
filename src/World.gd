extends Spatial

# Onready Private
onready var __first_platform_spawn_position:Vector3 = get_node("FirstPlatformSpawnPosition").global_transform.origin;

# Preload Private
var __floors:Array = [
	preload("res://src/gameobjects/CubeFloor/CubeFloor.tscn"),
	preload("res://src/gameobjects/CubeFloor/CubeFloorWithRamp.tscn"),
	preload("res://src/gameobjects/CubeFloor/CubeFloorWithSpeedBoost.tscn"),
	preload("res://src/gameobjects/CubeFloor/CubeFloorSlope1.tscn"),
];

# Fields Private
var __previous_floor:PlatformBase;
var __platforms_went_through:int = 0;

func __spawn_floor(previous_floor_position:Vector3)->PlatformBase:
	var random_floor:PackedScene = __floors[randi() % __floors.size()];
	var instance:PlatformBase = random_floor.instance();
	add_child(instance);
	instance.global_transform.origin = previous_floor_position - instance.start_position;
	instance.floor_enter_area.connect("body_entered", self, "__on_player_entered");
	__previous_floor = instance;
	return instance;
	
func __spawn_floors(num:int)->void:
	__platforms_went_through += 1;
	if(__platforms_went_through % num/2 == 0):
		var f = __previous_floor;
		for i in range(num):
			var spawn_pos:Vector3 = __first_platform_spawn_position if f == null else f.global_transform.origin + f.end_position;
			f = __spawn_floor(spawn_pos);
			
		print("Spawned 10 floors");
	
func __on_player_entered(body)->void:
	__spawn_floors(10);

func _ready()->void:
	__spawn_floors(10);
