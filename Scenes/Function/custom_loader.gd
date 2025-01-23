extends Node
class_name CustomLoader
## Master Class holding the resulting lists of resources from the 3 methods
## of resource loading demonstrated here. 
##
## You typically won't need a master class like this in your project once you
## have determined a choice method...
## However if you decide on a hybrid design... consider a Master Class i guess.


signal finished_load()

var material_glossary : Array[MaterialResource]
var recipe_glossary : Array[RecipeResource]

func get_material_by_name(mat_name : String) -> MaterialResource:
	var result : MaterialResource = null
	
	for mat in material_glossary:
		if mat.mat_name == mat_name:
			result = mat
	
	return result

