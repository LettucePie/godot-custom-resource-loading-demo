extends CustomLoader
class_name PackedLoader
## This Class demonstrates a resource structure where the Resource Objects
## are saved data blocks which are stored in an array.
## 
## This could be considered the most "Overlay Friendly" method, since the 
## process for adding and editing mostly requires using the mouse to click
## through the various objects within their arrays in the Inspector.[br]
## [br]
## Mileage may vary on this method, as you will find yourself encountering
## a plethora of bugs trying to setup this system. I would recommend making
## a @tool script to build the arrays automatically once they get overwhelming.


@export var donuts : Array[Resource]
@export var glazes : Array[Resource]
@export var recipes : Array[Resource]


func startup():
	material_glossary.append_array(donuts)
	material_glossary.append_array(glazes)
	recipe_glossary.append_array(recipes)
	print("Finished Packed Loader")
	print("I mean... Really just moved a data reference to a different spot...")
	emit_signal("finished_load")
