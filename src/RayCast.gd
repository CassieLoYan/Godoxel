extends RayCast

enum {
	ADD,
	REMOVE,
	PAINT
}

onready var voxel = preload("res://Voxel/Voxel.tscn")
onready var cam = get_tree().get_nodes_in_group("cam")[0] as InterpolatedCamera
onready var mesh = get_tree().get_nodes_in_group("mesh")[0] as MeshInstance
onready var voxel_world = get_parent().get_node("VoxelWorld")
var mode = ADD

var mirroring = [true,false,false]

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		set_indicator_pos(event.position)
	elif Input.is_action_pressed("action"):
		if event is InputEventMouseButton:
			var from = cam.project_ray_origin(event.position)
			var pos = from+cam.project_ray_normal(event.position) * 500
			translation=from
			cast_to=pos
			force_raycast_update() 
			match mode:
				ADD:
					add_voxel()
				REMOVE:
					remove_voxel()
				PAINT:
					paint_voxel()

func set_indicator_pos(position):
	var from = cam.project_ray_origin(position)
	var pos = from+cam.project_ray_normal(position) * 500
	translation=from
	cast_to=pos
	force_raycast_update()
	if mode == ADD:
		var point = get_collision_point()+(get_collision_normal()/4)
		point.x=stepify(point.x,0.5)
		point.z=stepify(point.z,0.5)
		point.y=stepify(point.y-0.25,0.5)
		mesh.global_transform.origin=point
		return
	var collider = get_collider()
	if collider is Voxel:
		mesh.global_transform.origin=collider.global_transform.origin

func create_voxel_at_point(point):
	if voxel_world.has_voxel_in_point(point):
		return
	var new_voxel = voxel.instance()
	voxel_world.add_child(new_voxel)
	new_voxel.set_material(Global.current_colour)
	new_voxel.global_transform.origin=point
	voxel_world.voxels[point]=new_voxel
	return


func _process(delta):
	if Input.is_action_just_pressed("add"):
		mode = ADD
		return
	if Input.is_action_just_pressed("remove"):
		mode = REMOVE
		return
	if Input.is_action_just_pressed("paint"):
		mode = PAINT
		return
	if Input.is_action_just_pressed("mirror_x"):
		mirroring[0]=!mirroring[0]
		return
	if Input.is_action_just_pressed("mirror_y"):
		mirroring[1]=!mirroring[1]
		return
	if Input.is_action_just_pressed("mirror_Z"):
		mirroring[2]=!mirroring[2]
		return

func add_voxel():
	var point = get_collision_point()+(get_collision_normal()/4)
	point.x=stepify(point.x,0.5)
	point.z=stepify(point.z,0.5)
	point.y=stepify(point.y-0.25,0.5)
	create_voxel_at_point(point)
	if mirroring[0]:
		point.x=-point.x
		create_voxel_at_point(point)
	if mirroring[1]:
		point.y=-point.y
		create_voxel_at_point(point)
	if mirroring[2]:
		point.z=-point.z
		create_voxel_at_point(point)
	return

func remove_voxel():
	if !is_colliding():
		print("not_colliding")
		return
	var collider = get_collider()
	print(collider)
	if collider is Voxel:
		voxel_world.voxels.erase(collider.global_transform.origin)
		collider.queue_free()



func paint_voxel():
	if !is_colliding():
		return
	var collider = get_collider()
	print(collider)
	if collider is Voxel:
		collider.set_material(Global.current_colour)
