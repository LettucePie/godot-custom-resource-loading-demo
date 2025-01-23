extends Button
class_name GridButton

signal selected(button_text)

func _ready():
	if is_connected("pressed", self._on_pressed):
		print("Connected")


## Assigns an Icon and Text to the Grid Button
func assign_icon_text(new_icon : Texture2D, new_text : String):
	self.text = new_text
	self.icon = new_icon


func _on_pressed():
	print(self.text, " Pressed")
	emit_signal("selected", self.text)
