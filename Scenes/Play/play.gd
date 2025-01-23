extends Control
class_name Play
## Interface to demonstrate and test the differing load types.

## Resources
@export var grid_button_scene : PackedScene
@export var unknown_tex : Texture2D
@export var JSON_loader_scene : PackedScene
@export var packed_loader_scene : PackedScene
@export var unpacked_loader_scene : PackedScene

## Loader Setup
enum LOADER {NONE, JSONLOAD, PACKED, UNPACKED}
var current_loader_type : LOADER = LOADER.NONE
var current_loader : CustomLoader = null
@onready var grid : GridContainer = $column_host/c2/GridContainer
var grid_buttons : Array = []

## Game Part
var last_selected_button : String = ""
@onready var slot_a : Button = $column_host/c2/Slots/SlotA
@onready var slot_b : Button = $column_host/c2/Slots/SlotB
@onready var result : Button = $column_host/c2/Slots/Result

# Called when the node enters the scene tree for the first time.
func _ready():
	clear_slots()


func _on_json_pressed():
	if current_loader_type != LOADER.NONE:
		_cleanup()
	print("Loading JSON Method")
	current_loader = JSON_loader_scene.instantiate()
	current_loader.connect("finished_load", self._populate_grid)
	add_child(current_loader)
	current_loader_type = LOADER.JSONLOAD
	if current_loader.has_method("startup"):
		current_loader.startup()


func _on_packed_pressed():
	if current_loader_type != LOADER.NONE:
		_cleanup()
	print("Loading Packed Method")
	current_loader = packed_loader_scene.instantiate()
	current_loader.connect("finished_load", self._populate_grid)
	add_child(current_loader)
	current_loader_type = LOADER.PACKED
	if current_loader.has_method("startup"):
		current_loader.startup()


func _on_unpacked_pressed():
	if current_loader_type != LOADER.NONE:
		_cleanup()
	print("Loading Unpacked Method")
	current_loader = unpacked_loader_scene.instantiate()
	current_loader.connect("finished_load", self._populate_grid)
	add_child(current_loader)
	current_loader_type = LOADER.UNPACKED
	if current_loader.has_method("startup"):
		current_loader.startup()


func _cleanup():
	print("Cleaning up Previous Loader")
	current_loader.queue_free()
	current_loader = null
	current_loader_type = LOADER.NONE
	_depopulate_grid()
	clear_slots()


func _populate_grid():
	for mat in current_loader.material_glossary:
		var new_button : GridButton = grid_button_scene.instantiate()
		new_button.assign_icon_text(mat.mat_icon, mat.mat_name)
		new_button.connect("selected", self.button_selected)
		grid_buttons.append(new_button)
		grid.add_child(new_button)


func _depopulate_grid():
	for grid_button in grid_buttons:
		if is_instance_valid(grid_button):
			grid_button.queue_free()
	grid_buttons.clear()


func clear_slots():
	slot_a.text = "Empty"
	slot_a.icon = null
	slot_b.text = "Empty"
	slot_b.icon = null
	result.text = ""
	result.icon = unknown_tex
	$column_host/c2/Status.text = ""


func button_selected(mat_name):
	last_selected_button = mat_name


func _on_slot_a_pressed():
	print("Slot A Pressed | Last Selected: ", last_selected_button)
	if last_selected_button == "":
		slot_a.text = "Empty"
		slot_a.icon = null
	else:
		var mat : MaterialResource = current_loader.get_material_by_name(
				last_selected_button)
		print("Assigning MaterialResource to Slot A: ", mat)
		slot_a.text = mat.mat_name
		print("Slot A Text: ", slot_a.text)
		slot_a.icon = mat.mat_icon
		last_selected_button = ""
	if current_loader_type != LOADER.NONE:
		run_result()


func _on_slot_b_pressed():
	print("Slot B Pressed")
	if last_selected_button == "":
		slot_b.text = "Empty"
		slot_b.icon = null
	else:
		var mat : MaterialResource = current_loader.get_material_by_name(
				last_selected_button)
		slot_b.text = mat.mat_name
		slot_b.icon = mat.mat_icon
		last_selected_button = ""
	if current_loader_type != LOADER.NONE:
		run_result()


func run_result():
	print("Running Result")
	$column_host/c2/Status.text = ""
	var mat1 : MaterialResource = null
	var mat2 : MaterialResource = null
	var result_out : String = "Unknown"
	
	if slot_a.text != "Empty":
		mat1 = current_loader.get_material_by_name(slot_a.text)
	if slot_b.text != "Empty":
		mat2 = current_loader.get_material_by_name(slot_b.text)
	for recipe in current_loader.recipe_glossary:
		if recipe.required_mats.has(mat1) and recipe.required_mats.has(mat2):
			result_out = recipe.result
	
	if mat1 != null and mat2 != null and result_out == "Unknown":
		$column_host/c2/Status.text = "Recipe not Available"
	
	if result_out != "Unknown":
		result.text = result_out
		var base : Texture2D = mat1.mat_icon
		var top : Texture2D = mat2.mat_icon
		if mat1.mat_type == MaterialResource.TYPE.GLAZE:
			top = mat1.mat_icon
			base = mat2.mat_icon
		result.icon = build_donut(base, top)
		$column_host/c2/Status.text = "Recipe Found!"
	else:
		result.text = "Unknown"
		result.icon = unknown_tex


func build_donut(base : Texture2D, top : Texture2D) -> Texture2D:
	var result : Texture2D = null
	
	var base_img : Image = base.get_image()
	var top_img : Image = top.get_image()
	var rect : Rect2i = Rect2i(Vector2i.ZERO, base_img.get_size())
	base_img.blend_rect(top_img, rect, Vector2i.ZERO)
	var img_tex : ImageTexture = ImageTexture.create_from_image(base_img)
	result = img_tex
	
	return result
