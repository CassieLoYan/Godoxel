extends Node

var current_colour = 0

var colour = Color(1,1,1)

var colour_ids = []
var materials = []

func _ready():
	yield(get_tree(),"idle_frame")
	var squares = get_tree().get_nodes_in_group("colour_squares")[0]
	var n = 0
	for square in squares.get_children():
		square.id = colour_ids.size()
		colour_ids.append(square)
		var new_material = SpatialMaterial.new()
		new_material.albedo_color=square.modulate
		materials.append(new_material)


func switch_colour(new_colour):
	current_colour=new_colour
	colour=colour_ids[new_colour].modulate

func create_texture_colour() -> Image:
	var image = Image.new()
	image.create(materials.size(),1,false,4)
	var c = 0
	image.lock()
	for material in materials:
		image.set_pixel(c,0,material.albedo_color)
		c+=1;
	image.unlock()
	return image

func has_colour(color):
	for i in colour_ids:
		if i.modulate == color:
			return true
	return false

func get_id_from_colour(colour):
	for i in colour_ids:
		if i.modulate == colour:
			return i.id
	return -1

func export_to_obj():
	return
