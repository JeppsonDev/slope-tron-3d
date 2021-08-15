extends Spatial

onready var __cpuparticle:CPUParticles = get_node("CPUParticles");
onready var __alive_timer:Timer = get_node("AliveTimer");

var __alpha:float = 1.0;
var __stopping:bool = false;

func _ready()->void:
	__alive_timer.connect("timeout", self, "stop");
	__alpha = 0;
	__cpuparticle.color_ramp.set_color(1, Color(1,1,1,__alpha));
	
func _process(delta):
	if(__alpha > 0 and __stopping):
		__cpuparticle.color_ramp.set_color(1, Color(1,1,1,__alpha));
		__alpha -= 1 * delta;
	if(__alpha <= 0 and __stopping):
		__stopping = false;
		__alpha = 0;

func start()->void:
	__alpha = 1;
	__cpuparticle.one_shot = false;
	__cpuparticle.emitting = true;
	__alive_timer.start();
	__cpuparticle.color_ramp.set_color(1, Color(1,1,1,__alpha));
	
func stop()->void:
	__stopping = true;
