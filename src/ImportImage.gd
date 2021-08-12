extends FileDialog

signal start_import(path)

func _on_Button_pressed():
	popup_centered()


func _on_FileDialog2_confirmed():
	emit_signal("start_import",current_path)
