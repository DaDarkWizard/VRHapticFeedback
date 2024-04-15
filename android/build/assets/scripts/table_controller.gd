extends MeshInstance3D

signal moved(location)

func _on_right_hand_button_pressed(button_name):
	if button_name == "grip_click":
		self.global_position = get_tree().current_scene\
			.get_child(0).get_child(2).global_position + Vector3(0, -0.5, 0)
		moved.emit(self.global_position)

var lefton = true;
var righton = true;

func _on_right_hand_pose_matcher_new_pose(previous_pose, pose):
	if pose == "OK":
		righton = true;
		check_table_teleport();
	else:
		righton = false;


func _on_left_hand_pose_matcher_new_pose(previous_pose, pose):
	if pose == "OK":
		lefton = true;
		check_table_teleport();
	else:
		lefton = false;
		
func check_table_teleport():
	if lefton and righton:
		var right_position = get_tree().current_scene\
			.get_child(0).get_child(2).global_position
		var left_position = get_tree().current_scene\
			.get_child(0).get_child(1).global_position
		
		var average_position = Vector3(
			right_position.x + left_position.x / 2.0,
			right_position.y + left_position.y / 2.0,
			right_position.z + left_position.z / 2.0
		);
		
		self.global_position = average_position + Vector3(0, -0.4, 0)
		moved.emit(self.global_position)
