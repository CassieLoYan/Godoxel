extends Position3D

onready var cam = $Camera

func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("rotate"):
			rotation_degrees.x+=event.relative.y/3
			rotation_degrees.y+=event.relative.x/3
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_WHEEL_UP:
			cam.transform.origin.z-=0.5;
		if event.button_index == BUTTON_WHEEL_DOWN:
			cam.transform.origin.z+=0.5;

func _process(delta):
	var move_dir = Vector3.ZERO
	move_dir+=((Input.get_action_strength("right")-Input.get_action_strength("left"))*global_transform.basis.x)
	move_dir+=((Input.get_action_strength("forwards")-Input.get_action_strength("backwards"))*-global_transform.basis.z)
	move_dir+=((Input.get_action_strength("up")-Input.get_action_strength("down"))*global_transform.basis.y)
	transform.origin+=move_dir*delta
