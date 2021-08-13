extends MeshInstance

onready var col = $StaticBody/CollisionShape
func change_size(new_size):
	mesh.size=Vector2(float(new_size)/2.0,float(new_size)/2.0)
	col.shape.extents=Vector3(float(new_size)/4.0,0.5,float(new_size)/4.0)
