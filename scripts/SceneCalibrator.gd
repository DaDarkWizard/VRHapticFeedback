extends Node3D

var lefton = false;
var righton = false;

var leftfist = false;
var rightfist = false;

var mode = 0;

func on_calibrate_pressed():
	mode = 0;

func _on_left_hand_pose_matcher_new_pose(previous_pose, pose):
	if pose == "OK":
		lefton = true;
		leftfist = false;
		calibrate_hands();
	elif pose == "Fist":
		lefton = false;
		leftfist = true;
		calibrate_hands();
	else:
		lefton = false;
		leftfist = false;


func _on_right_hand_pose_matcher_new_pose(previous_pose, pose):
	if pose == "OK":
		righton = true;
		rightfist = false;
		calibrate_hands();
	elif pose == "Fist":
		righton = false;
		rightfist = true;
		calibrate_hands();
	else:
		righton = false;
		rightfist = false;

func calibrate_hands():
	if lefton and righton:
		if mode == 0:
			calibrate_point_1();
			mode += 1;
		elif mode == 1:
			calibrate_point_2();
			mode += 1;
	if leftfist and rightfist:
		mode = 0;


func calibrate_point_1():
	
	# Get the position of the left and right hands.
	var right_position = get_tree().current_scene\
		.get_child(0).get_child(2).get_child(0).get_child(1).global_position
	var left_position = get_tree().current_scene\
		.get_child(0).get_child(1).get_child(0).get_child(1).global_position
	
	# Get the center point between the hands.
	var average_position = Vector3(
		(right_position.x + left_position.x) / 2.0,
		(right_position.y + left_position.y) / 2.0,
		(right_position.z + left_position.z) / 2.0
	);
	
	# Set the first calibration point.
	$OuterCallibration/CallibratePoint1.global_position = average_position;
	
	
	# Try to get the room oriented a little bit.
	
	# Do rotation first.
	# Cross the vector from the left to the right hand with
	# itself lowered a little bit to get a vector pointing in the right
	# direction.
	var dir_vector = right_position - left_position;
	var rotate_vector = dir_vector.cross(dir_vector + Vector3(0, -0.1, 0));
	
	# Check the angle to the direction vector and figure out which way to turn.
	var rot_amount = rotate_vector.angle_to(Vector3(1, 0, 0))
	if rotate_vector.z > 0:
		rot_amount = -rot_amount;
	
	# This is from the previous one-stop orientation method, but it's not
	# really hurting anyone.
	#self.global_rotation = Vector3(0, 0, 0)
	$Mover.transform.basis = Basis();
	# Rotate the scene.
	$Mover.global_transform = $Mover.global_transform.rotated(Vector3(0, 1, 0), rot_amount)
	$Mover.global_transform = $Mover.global_transform.rotated(Vector3(0, 1, 0), PI)
	
	# Now figure out how much we need to translate and do it.
	var translation_diff = $OuterCallibration/CallibratePoint1.global_position - \
						$Mover/InnerCallibration/SetPoint1.global_position;
	
	$Mover.global_position = $Mover.global_position + translation_diff;

func calibrate_point_2():
	# Get the position of the left and right hands.
	var right_position = get_tree().current_scene\
		.get_child(0).get_child(2).get_child(0).get_child(1).global_position
	var left_position = get_tree().current_scene\
		.get_child(0).get_child(1).get_child(0).get_child(1).global_position
		
	# Get the center point between the hands.
	var average_position = Vector3(
		(right_position.x + left_position.x) / 2.0,
		(right_position.y + left_position.y) / 2.0,
		(right_position.z + left_position.z) / 2.0
	);
	
	# Set the second calibration point.
	$OuterCallibration/CallibratePoint2.global_position = average_position;
	
	# Try to get the room oriented a little bit more.
	
	# Do rotation first.
	# Cross the vector from the left to the right hand with
	# itself lowered a little bit to get a vector pointing in the right
	# direction.
	var dir_vector = $OuterCallibration/CallibratePoint1.global_position - \
				$OuterCallibration/CallibratePoint2.global_position;
	var rotate_vector = dir_vector.cross(dir_vector + Vector3(0, -0.1, 0));
	
	# Check the angle to the direction vector and figure out which way to turn.
	var rot_amount = rotate_vector.angle_to(Vector3(1, 0, 0))
	if rotate_vector.z > 0:
		rot_amount = -rot_amount;
	
	# Reset the room orientation before rotating.
	$Mover.transform.basis = Basis();
	
	# Rotate the scene.
	$Mover.global_transform = $Mover.global_transform.rotated(Vector3(0, 1, 0), rot_amount)
	$Mover.global_transform = $Mover.global_transform.rotated(Vector3(0, 1, 0), PI)
	
	# Now figure out how much we need to translate and do it.
	var translation_diff1 = $OuterCallibration/CallibratePoint1.global_position - \
						$Mover/InnerCallibration/SetPoint1.global_position;
	
	var translation_diff2 = $OuterCallibration/CallibratePoint2.global_position - \
						$Mover/InnerCallibration/SetPoint2.global_position;
	
	var av_translation_diff = (translation_diff1 + translation_diff2) / 2;
	
	$Mover.global_position = $Mover.global_position + av_translation_diff;
