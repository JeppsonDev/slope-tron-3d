extends Control

func _input(event):
	if event is InputEventKey and event.pressed:
		queue_free();
	if event is InputEventMouse and event.is_pressed():
		queue_free();
	if event is InputEventScreenTouch and event.is_pressed():
		queue_free();
