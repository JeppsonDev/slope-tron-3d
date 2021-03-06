extends Spatial
class_name GameWorld

signal score_increased(score);

# Onready Private
onready var __first_platform_spawn_position:Vector3 = get_node("FirstPlatformSpawnPosition").global_transform.origin;
onready var __thirdPersonFollowCamera:ThirdPersonFollowCamera = get_node("ThirdPersonFollowCamera");
onready var __bike:Bike = get_node("Bike");

# Preload Private
var __floors_easy:Array = [
	#preload("res://src/gameobjects/CubeFloor/CubeFloor.tscn"),
	preload("res://src/gameobjects/CubeFloor/CubeFloorWithRamp.tscn"),
	preload("res://src/gameobjects/CubeFloor/CubeFloorWithSpeedBoost.tscn"),
	preload("res://src/gameobjects/CubeFloor/CubeFloorStraightCurve.tscn"),
	preload("res://src/gameobjects/CubeFloor/CubeFloorLean.tscn"),
];

var __floors_med:Array = [
	preload("res://src/gameobjects/CubeFloor/CubeFloor.tscn"),
	preload("res://src/gameobjects/CubeFloor/CubeFloorWithRamp.tscn"),
	preload("res://src/gameobjects/CubeFloor/CubeFloorWithSpeedBoost.tscn"),
	preload("res://src/gameobjects/CubeFloor/CubeFloorSlope2.tscn"),
	preload("res://src/gameobjects/CubeFloor/CubeFloorBigLeap.tscn"),
	preload("res://src/gameobjects/CubeFloor/CubeFloorStraightCurve.tscn"),
	preload("res://src/gameobjects/CubeFloor/CubeFloorLean.tscn"),
];

var __floors_hard:Array = [
	preload("res://src/gameobjects/CubeFloor/CubeFloor.tscn"),
	preload("res://src/gameobjects/CubeFloor/CubeFloorWithRamp.tscn"),
	preload("res://src/gameobjects/CubeFloor/CubeFloorWithSpeedBoost.tscn"),
	preload("res://src/gameobjects/CubeFloor/CubeFloorTriple.tscn"),
	preload("res://src/gameobjects/CubeFloor/CubeFloorWithRoof.tscn"),
	preload("res://src/gameobjects/CubeFloor/CubeFloorBigLeap.tscn"),
	preload("res://src/gameobjects/CubeFloor/CubeFloorStraightCurve.tscn"),
	preload("res://src/gameobjects/CubeFloor/CubeFloorLean.tscn"),
];

# Fields Private
var __previous_floor:PlatformBase;
var __dequeue_floor_stack:Array;
var __previous_floor_index:int = 0;
var __platforms_went_through:int = 0;
var __score:int = 0;
var __dead=false;
var __y_to_lose:float = -500;

# Onready Public
onready var bike:Bike = get_node("Bike");

# Gets a new index except for previous floor index. 
func __generate_floor_index()->int:
	randomize();
	var val = 0;
	
	if (__score >= 0 and __score < 2):
		val = randi() % (__floors_easy.size()-1);
		if(val >= __previous_floor_index):
			val += 1;
			__previous_floor_index = val;
			
	if (__score >= 2 and __score < 16):
		val = randi() % (__floors_med.size()-1);
		if(val >= __previous_floor_index):
			val += 1;
			__previous_floor_index = val;
			
	if (__score >= 16):
		val = randi() % (__floors_hard.size()-1);
		if(val >= __previous_floor_index):
			val += 1;
			__previous_floor_index = val;
	return val;
	
func __get_floor(floor_index):
	if (__score >= 0 and __score < 2):
		return __floors_easy[floor_index];
	if (__score >= 2 and __score < 16):
		return __floors_med[floor_index];
	if (__score >= 16):
		return __floors_hard[floor_index];

# Spawns a floor relative to the previous floor position
func __spawn_floor(previous_floor_position:Vector3)->PlatformBase:
	var floor_index = __generate_floor_index();
	
	var random_floor:PackedScene = __get_floor(floor_index);
	var instance:PlatformBase = random_floor.instance();
	add_child(instance);
	instance.global_transform.origin = previous_floor_position - instance.start_position;
	instance.floor_enter_area.connect("body_entered", self, "__on_player_entered");
	instance.restart_zone.connect("body_entered", self, "__on_player_entered_restartzone");
	instance.connect("passed_end_area", self, "__on_player_exited");
	__previous_floor = instance;
	__previous_floor_index = floor_index
	
	__dequeue_floor_stack.append(instance);
	
	return instance;
	
func __spawn_floors(num:int)->void:
	if(__platforms_went_through % 2 == 0):
		__dequeue_floors();
		
		var f = __previous_floor;
		for i in range(num):
			var spawn_pos:Vector3 = __first_platform_spawn_position if f == null else f.global_transform.origin + f.end_position;
			f = __spawn_floor(spawn_pos);
			
		print("Spawned ", num, " floors");
		
	__platforms_went_through += 1;
	
func __dequeue_floors()->void:
	print("Dequeued ", 4, " floors");
	if(__dequeue_floor_stack.size() > 0):
		for i in range(4, 0):
			__dequeue_floor_stack[i].queue_free();
		#__dequeue_floor_stack.clear();
	
func __on_player_entered(body)->void:
	__spawn_floors(4);
	
func __on_player_entered_restartzone(body):
	if(__dead):
		return;
	
	__dead = true;
	
	var highscore = Application.save_game.get_value("highscore");
	
	if(highscore < __score):
		Application.save_game.set_value("highscore", __score);
		Application.save_game.save_game();
		highscore = __score;
	
	Application.scene_manager.current_scene.ui.get_node("DeathScreen").show();
	Application.scene_manager.current_scene.ui.get_node("DeathScreen").init(__score, highscore);
	
func __on_player_exited()->void:
	__score = __score + 1;
	__y_to_lose = $Bike.global_transform.origin.y - 500;
	get_owner().ui.score_label.text = str(__score);
	emit_signal("score_increased", __score);

func _process(delta)->void:
	if($Bike.global_transform.origin.y < __y_to_lose):
		__on_player_entered_restartzone($Bike);

func _ready()->void:
	__spawn_floors(4);
	__bike.connect("speedup", __thirdPersonFollowCamera, "start_warpdrive");
	
