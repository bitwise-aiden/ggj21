extends Node

var count = 0

func _process(delta: float) -> void:
	print("hello")

	if Input.is_action_just_pressed("ui_accept"):
		var capture
		capture = get_viewport().get_texture().get_data()
		capture.flip_y()
		capture.save_png("user://screenshot_%d.png" % count)

		count += 1

		OS.shell_open(OS.get_user_data_dir())
