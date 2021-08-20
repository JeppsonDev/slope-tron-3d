extends ColorRect
class_name SceneTransitionSlide

export(bool) var _in:bool;

onready var animation_player:AnimationPlayer = get_node("AnimationPlayer");

func _ready()->void:
	material.set_shader_param("_in", _in);
	#color = Color(255,255,255,0);
	
func transition_in():
	#color = Color(255,255,255,255);
	material.set_shader_param("_in", false);
	animation_player.play_backwards("transition");
	
func transition_out():
	#color = Color(255,255,255,255);
	material.set_shader_param("_in", false);
	animation_player.play("transition");
