extends FileDialog

signal start_import(path,palette)

var palette = false

func _on_Button_pressed():
	popup_centered()
	palette=false


func _on_FileDialog2_confirmed():
	emit_signal("start_import",current_path,palette)


func _on_Palette_pressed():
	popup_centered()
	palette=true
