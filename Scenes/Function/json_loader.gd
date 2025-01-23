extends CustomLoader
class_name JSONLoader
## This Class demonstrates one of many possible ways to utilize JSON Parsing
## to load in resources. 
## 
## In this setup a Data Directory is specified in the inspector, which is 
## searched through for any and all .json files. Those files are then sent to
## a function meant to decipher their contents and connect them to 
## usable resource types. [br]
## ____ [br]
## This method has several advantages, mainly in allowing the use of outside
## tools to help arrange and "metabolize" your assets and resources. You simply
## need to convert a Data Table (such as an Excel Document) into a JSON file.[br]
## ____ [br]
## This biggest drawback to this method is step process the resources are
## loaded in. Godot prefers to have all it's associated resources connected
## at the compilation/export step. This method however will load in addendum.
## You may need to research your target platform for how it supports this,
## and adjust accordingly.


@export_dir var data_dir : String


func startup():
	print("Starting up JSONLoader")
	_dir_contents(data_dir)
	if recipe_glossary.size() > 0:
		for recipe in recipe_glossary:
			if recipe.required_mats.size() < recipe.required_mat_names.size():
				print("Connecting Recipe to MaterialResources")
				recipe.required_mats.clear()
				for mat_str in recipe.required_mat_names:
					recipe.required_mats.append(get_material_by_name(mat_str))
	print("JSONS in dir: ", data_dir, "  all Glossarized.")
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
				if file_name.contains(".json"):
					_glossarize(path + "/" + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")



func _glossarize(path):
	print("JSONLoader Glossarizing path: ", path)
	var file : FileAccess = FileAccess.open(path, FileAccess.READ)
	var json : JSON = JSON.new()
	var error = json.parse(file.get_as_text())
	if error == 0:
		print("No Issue Parsing :)")
	else:
		print("Error Parsing!")
		print(error)
	if json.data.has("Donuts"):
		print("Loading in Donuts...")
		var donut_dicts = json.data.get("Donuts")
		for donut_info in donut_dicts:
			var new_donut : MaterialResource = MaterialResource.new()
			new_donut.mat_name = donut_info["donut_name"]
			new_donut.mat_icon = load(donut_info["donut_icon"])
			new_donut.mat_type = MaterialResource.TYPE.DONUT
			material_glossary.append(new_donut)
	if json.data.has("Glazes"):
		print("Loading in Glazes...")
		var glaze_dicts = json.data.get("Glazes")
		for glaze_info in glaze_dicts:
			var new_glaze : MaterialResource = MaterialResource.new()
			new_glaze.mat_name = glaze_info["glaze_name"]
			new_glaze.mat_icon = load(glaze_info["glaze_icon"])
			new_glaze.mat_type = MaterialResource.TYPE.GLAZE
			material_glossary.append(new_glaze)
	if json.data.has("Recipes"):
		print("Loading in Recipes...")
		var recipe_dicts = json.data.get("Recipes")
		for recipe_info in recipe_dicts:
			var new_recipe : RecipeResource = RecipeResource.new()
			new_recipe.result = recipe_info["result"]
			new_recipe.required_mat_names = PackedStringArray(
					recipe_info["requires"])
			recipe_glossary.append(new_recipe)
	file.close()
