extends FileDialog


signal export_obj(path,name)

func _on_Button_pressed():
	popup_centered()


func _on_FileDialog_confirmed():
	print(current_dir+current_file)
	emit_signal("export_obj",current_dir,current_file)
