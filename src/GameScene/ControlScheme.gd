extends Control

func _process(delta):
	if(Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("right") or Input.is_action_pressed("left")):
		queue_free();
