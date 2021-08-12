extends ColorRect

var id = 0

func _ready():
	modulate = Color(rand_range(0,1),rand_range(0,1),rand_range(0,1))


func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		Global.switch_colour(id)
		return
