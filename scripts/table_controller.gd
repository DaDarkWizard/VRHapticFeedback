extends MeshInstance3D



func _on_right_hand_button_pressed(button_name):
	if button_name == "grip_click":
		self.global_position = get_tree().current_scene\
			.get_child(0).get_child(2).global_position + Vector3(0, -0.08, 0)
