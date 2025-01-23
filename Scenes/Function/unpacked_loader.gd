extends CustomLoader
class_name UnpackedLoader
## This Class demonstrates how to load in Custom Resource Objects without
## needing to pack them into an array first.
##
## This method has a couple tricks to it, however it is probably the fastest
## to develop with once it has been setup. It's important to set [b]Convert
## Text Resources to Binary[b/] as FALSE in the project settings. Also when
## exporting, you need to make sure you include the folders of Resource Objects
## in the export.[br]
## [br]
## This method tries to create the most ideal and human approachable structure.
## Once you have the loader setup to acknowledge the target files and types,
## you can simply create as many Custom Resource Objects as you like; no extra
## steps required.


@export_dir var data_dir : String

func startup():
	_dir_contents(data_dir)
	print("Finished Unpacked Loader")
	emit_signal("finished_load")


func _dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				_dir_contents(path + "/" + file_name)
			else:
				if file_name.contains(".tres"):
					_associate(path + "/" + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")


func _associate(path):
	pass
	if _parse_it(path) == 1:
		print("MaterialResource File Found")
		material_glossary.append(load(path))
	elif _parse_it(path) == 2:
		print("RecipeResource File Found")
		recipe_glossary.append(load(path))


func _parse_it(file) -> int:
	var result : int = 0
	
	var res_file : FileAccess = FileAccess.open(file, FileAccess.READ)
	var content = res_file.get_as_text()
	if content.contains("MaterialResource"):
		result = 1
	elif content.contains("RecipeResource"):
		result = 2
	res_file.close()
	
	return result
