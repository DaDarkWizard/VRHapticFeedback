extends Label3D



func _on_right_hand_button_pressed(name):
	self.text = name


func _on_folding_table_moved(location):
	self.text = location.to_string() # Replace with function body.
