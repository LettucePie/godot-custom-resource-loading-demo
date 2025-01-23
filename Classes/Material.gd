extends Resource
class_name MaterialResource
## A Resource Class for Resource Materials in the Demo.
## \n
## Use this by Right Clicking on a folder and adding a new Resource.
## Navigate to the MaterialResource and set the values in the Inspector.

@export var mat_name : String = ""
@export var mat_icon : Texture2D
enum TYPE {DONUT, GLAZE}
@export var mat_type : TYPE = TYPE.DONUT
