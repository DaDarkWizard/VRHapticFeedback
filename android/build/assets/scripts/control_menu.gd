extends Node3D

signal calibrate;

func body_entered(body: Node3D):
	#$XRButton.mesh.material.albedo_color = Color(1, 0, 0);
	#$Button/ButtonMesh1.visible = false;
	#$Button/ButtonMesh2.visible = true;
	#$Timer.start(0.5);
	calibrate.emit();

func timer_end():
	#$Button/ButtonMesh1.visible = true;
	#$Button/ButtonMesh2.visible = false;
	pass

func calibrate_pressed(key: Key):
	#$XRButton.mesh.material.albedo_color = Color(1, 0, 0);
	calibrate.emit();

