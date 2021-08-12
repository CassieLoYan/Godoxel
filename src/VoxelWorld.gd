extends Spatial
onready var voxel = preload("res://Voxel/Voxel.tscn")
var sizes = [
	Vector3(-0.25,-0.25,-0.25),
	Vector3(0.25,-0.25,-0.25),
	Vector3(-0.25,0.25,-0.25),
	Vector3(0.25,0.25,-0.25),
	Vector3(-0.25,-0.25,0.25),
	Vector3(0.25,-0.25,0.25),
	Vector3(-0.25,0.25,0.25),
	Vector3(0.25,0.25,0.25),
	
]

var voxels = {}


func has_voxel_in_point(point):
	if !(point in voxels):
		return false
	return true

func _ready():
	yield(get_tree(),"idle_frame")
	yield(get_tree(),"idle_frame")
#	import_image(null)

func create_material(path,name):
	var file = File.new()
	name.erase(name.length()-4,4)

	file.open(path+"/"+name+".mtl",File.WRITE)
	Global.create_texture_colour().save_png(path+"/colours.png")
	var text = """
newmtl colours
Ka 0.000 0.000 0.000
Kd 1.000 1.000 1.000
Ks 0.000 0.000 0.000
map_Kd colours.png
	"""
	file.store_string(text)
	file.close()

func export_to_obj(path,name):
	print(path+name)
	create_material(path,name)
	name.erase(name.length()-4,4)
	var verts = []
	var faces = []
	var colours = []
	for voxel in get_children():
		var new_verts = []
		var new_faces = []
		for i in sizes:
			var new_vert = voxel.global_transform.origin
			new_vert-=i
			#new_vert/=25.0
			verts.append(new_vert)
		var amount_of_faces = verts.size()-8
		new_faces = [
			Vector3(1+amount_of_faces, 2+amount_of_faces, 3+amount_of_faces),
			Vector3(2+amount_of_faces, 3+amount_of_faces, 4+amount_of_faces),
			Vector3(2+amount_of_faces, 6+amount_of_faces, 4+amount_of_faces),
			Vector3(6+amount_of_faces, 4+amount_of_faces, 8+amount_of_faces),
			Vector3(5+amount_of_faces, 6+amount_of_faces, 7+amount_of_faces),
			Vector3(6+amount_of_faces, 7+amount_of_faces, 8+amount_of_faces),
			Vector3(5+amount_of_faces, 1+amount_of_faces, 3+amount_of_faces),
			Vector3(3+amount_of_faces, 7+amount_of_faces, 5+amount_of_faces),
			Vector3(3+amount_of_faces, 7+amount_of_faces, 4+amount_of_faces),
			Vector3(4+amount_of_faces, 8+amount_of_faces, 7+amount_of_faces),
			Vector3(1+amount_of_faces, 2+amount_of_faces, 5+amount_of_faces),
			Vector3(2+amount_of_faces, 6+amount_of_faces, 5+amount_of_faces),
		]
		for i in 12:
			colours.append(voxel.m_id+1)
		faces.append_array(new_faces)
	print(verts)

	var wfobj : String
	wfobj+=("mtllib "+name+".mtl")
	wfobj+="\n usemtl colours\n"

# vertices

	var number_of_colours = Global.materials.size()
	for i in number_of_colours:
		wfobj+= ("vt "+str((float(i)/number_of_colours)+0.0001)+" 0.5"+"\n")
	for i in verts:
		wfobj+= ("v "+str(i.x)+" "+str(i.y)+" "+str(i.z)+"\n")
	var n = 0
	for i in faces:
		wfobj+= ("f "+str(i.x)+"/"+str(colours[n])+" "+str(i.y)+"/"+str(colours[n])+" "+str(i.z)+"/"+str(colours[n])+"\n")
		n+=1
	var file = File.new()
	file.open(path+"/"+name+".obj",File.WRITE)
	file.store_string(wfobj)
	file.close()

	return


func _on_FileDialog_export_obj(path, name):
	export_to_obj(path,name)

func import_image(image):
	var ima = Image.new()
	ima.load(image)
	var center = Vector2(ima.get_width()/2,ima.get_height()/2)
	ima.lock()
	var height = ima.get_height()
	var width = ima.get_width()
	for x in width:
		for y in height:
			var color = ima.get_pixelv(Vector2(x,y))
			if !Global.has_colour(color):
				Global.colour_ids[Global.current_colour].modulate=color
				Global.materials[Global.current_colour].albedo_color=color
				Global.current_colour+=1;
	var pixels_per_Frame = 10
	var current_pixel = 0
	for x in width:
		for y in height:
			var color = ima.get_pixelv(Vector2(x,y))
			Global.current_colour=Global.get_id_from_colour(color)
			create_voxel_at_point(Vector3((width-x-center.x)/2.0,(height-y-center.y)/2.0,0))
			current_pixel+=1
			if current_pixel==pixels_per_Frame:
				yield(get_tree(),"idle_frame")
				current_pixel=0
			
	ima.unlock()
	return

func create_voxel_at_point(point):
	if has_voxel_in_point(point):
		return
	var new_voxel = voxel.instance()
	add_child(new_voxel)
	new_voxel.set_material(Global.current_colour)
	new_voxel.global_transform.origin=point
	voxels[point]=new_voxel
	return
