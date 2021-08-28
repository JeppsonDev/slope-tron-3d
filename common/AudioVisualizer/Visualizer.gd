extends Spatial
class_name Visualizer

# Gonkee's audio visualiser for Godot 3.2 - full tutorial https://youtu.be/AwgSICbGxJM
# If you use this, I would prefer if you gave credit to me and my channel

export(Gradient) var __gradient;

onready var spectrum = AudioServer.get_bus_effect_instance(2, 0)

var definition = 20
var total_w = 400
var total_h = 30 #200
var min_freq = 20
var max_freq = 20000

var max_db = 0
var min_db = -40

var accel = 20
var histogram = []

func _ready():
	for i in range(definition):
		get_child(i).get_active_material(0).emission = __gradient.interpolate((float(0)/float(100)));
	get_parent().get_parent().connect("score_increased", self, "__on_score_increased");
	max_db += Application.main_music.volume_db
	min_db += Application.main_music.volume_db
	
	for i in range(definition):
		histogram.append(0)
		
func __on_score_increased(score)->void:
	for i in range(definition):
		get_child(i).get_active_material(0).emission = __gradient.interpolate((float(score)/float(100)));

func _process(delta):
	var freq = min_freq
	var interval = (max_freq - min_freq) / definition
	
	for i in range(definition):
		
		var freqrange_low = float(freq - min_freq) / float(max_freq - min_freq)
		freqrange_low = freqrange_low * freqrange_low * freqrange_low * freqrange_low
		freqrange_low = lerp(min_freq, max_freq, freqrange_low)
		
		freq += interval
		
		var freqrange_high = float(freq - min_freq) / float(max_freq - min_freq)
		freqrange_high = freqrange_high * freqrange_high * freqrange_high * freqrange_high
		freqrange_high = lerp(min_freq, max_freq, freqrange_high)
		
		var mag = spectrum.get_magnitude_for_frequency_range(freqrange_low, freqrange_high)
		mag = linear2db(mag.length())
		mag = (mag - min_db) / (max_db - min_db)
		
		mag += 0.3 * (freq - min_freq) / (max_freq - min_freq)
		mag = clamp(mag, 0.05, 1)
		
		histogram[i] = lerp(histogram[i], mag, accel * delta)
		
	__draw_horizontal_3d_visualizer();
	
	#update()

#func _draw():
#	__draw_round_visualizer();
#
#func __draw_horizontal_visualizer()->void:
#	# Horizontal Visualiser
#	var draw_pos = Vector2(0, 0)
#	var w_interval = total_w / definition
#
#	draw_line(Vector2(0, -total_h), Vector2(total_w, -total_h), Color.crimson, 2.0, true)
#
#	for i in range(definition):
#		draw_line(draw_pos, draw_pos + Vector2(0, -histogram[i] * total_h), Color.crimson, 4.0, true)
#		draw_pos.x += w_interval
		
func __draw_horizontal_3d_visualizer()->void:
	# Horizontal Visualiser
	var draw_pos = Vector2(0, 0)
	var w_interval = total_w / definition

#void draw_line(from: Vector2, to: Vector2, color: Color, width: float = 1.0, antialiased: bool = false)
	#draw_line(Vector2(0, -total_h), Vector2(total_w, -total_h), Color.crimson, 2.0, true)

	var avgLoudness:float = 0;

	for i in range(definition):
		var loudness = abs(-histogram[i] * total_h);
		
		avgLoudness += loudness;
		
		get_child(i).scale.y = loudness;
		get_child(i).transform.origin.y = get_child(i).scale.y/2;
		
	avgLoudness = avgLoudness / definition*2;
	
	#print(avgLoudness)
	
	#Application.scene_manager.current_scene.get_node("GameWorld/DirectionalLight").light_energy = avgLoudness * 0.05;
	#print(Application.scene_manager.current_scene.get_node("GameWorld/DirectionalLight").light_energy)
		
		#draw_line(draw_pos, draw_pos + Vector2(0, -histogram[i] * total_h), Color.crimson, 4.0, true)
		#draw_pos.x += w_interval
#
#func __draw_round_visualizer()->void:
#	# Round Visualiser
#	var angle = PI
#	var angle_interval = 2 * PI / definition
#	var radius = 50
#	var length = 50
#
#	for i in range(definition):
#		var normal = Vector2(0, -1).rotated(angle)
#		var start_pos = normal * radius
#		var end_pos = normal * (radius + histogram[i] * length)
#		draw_line(start_pos, end_pos, Color.dodgerblue, 4.0, true)
#		angle += angle_interval
