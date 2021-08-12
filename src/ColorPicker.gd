extends ColorPicker


func _process(delta):
	if Input.is_action_just_pressed("show_colourpicker"):
		visible = !visible


func _on_ColorPicker_color_changed(color):
	Global.colour_ids[Global.current_colour].modulate=color
	Global.materials[Global.current_colour].albedo_color=color
	
