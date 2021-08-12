extends StaticBody
class_name Voxel


onready var mesh = $MeshInstance

var m_id = 0

func set_material(material_id):
	print(Global.materials[material_id].albedo_color)
	mesh.material_override = Global.materials[material_id]
	m_id = material_id
