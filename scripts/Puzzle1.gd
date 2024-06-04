extends Node2D

var button1_active:bool = false
var button2_active:bool = false
var solved = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_button_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	button1_active = true
	check()
	
func _on_button_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	button1_active = false

func _on_button_2_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	button2_active = true
	check()
	
func _on_button_2_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	button2_active = false
	
func check():
	print("Checking")
	if button1_active and button2_active and not solved:
		solved = true
		$SpikeTrap1.spikes_off()
		$SpikeTrap2.spikes_off()
		$SpikeTrap3.spikes_off()
		
		
