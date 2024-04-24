extends Node3D

var lefton = false;
var righton = false;

func _on_left_hand_pose_matcher_new_pose(previous_pose, pose):
	if pose == "OK":
		lefton = true;
		calibrate_hands();
	else:
		lefton = false;


func _on_right_hand_pose_matcher_new_pose(previous_pose, pose):
	if pose == "OK":
		righton = true;
		calibrate_hands();
	else:
		righton = false;

func calibrate_hands():
	if lefton and righton:
		var right_position = get_tree().current_scene\
			.get_child(0).get_child(2).global_position
		var left_position = get_tree().current_scene\
			.get_child(0).get_child(1).global_position
		var head_position = get_tree().current_scene\
			.get_child(0).get_child(0).global_position
		
		var average_position = Vector3(
			right_position.x + left_position.x / 2.0,
			right_position.y + left_position.y / 2.0,
			right_position.z + left_position.z / 2.0
		);
		
		var dir_vector = right_position - left_position;
		
		var dir_vector2 = dir_vector + Vector3(0, -0.1, 0);
		
		var rotate_vector = dir_vector.cross(dir_vector2);
		
		var rot_amount = rotate_vector.angle_to(Vector3(1, 0, 0))
		
		
		
		self.global_rotation = Vector3(0, 0, 0)
		
		if rotate_vector.z > 0:
			rot_amount = -rot_amount;
		
		self.global_transform = self.global_transform.rotated(Vector3(0, 1, 0), rot_amount)
		self.global_transform = self.global_transform.rotated(Vector3(0, 1, 0), PI)
		
		self.global_position = average_position + Vector3(0.3, -1.17, -0.3)
