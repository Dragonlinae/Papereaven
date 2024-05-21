class_name Attack

extends Node2D

var atk_name: String = ""
var atk_total_duration: float = 0.0
var atk_time: float = 0.0
var atk_metadata: Array = []
var atk_data: Array = []
var curr_atk_data: Array = []
var next_atk_data_index: int = 1
var player_character: Node2D

func _init(attack_name: String, player_controller: Node2D = null):
	player_character = player_controller
	atk_name = attack_name
	atk_metadata = FileAccess.open("res://scripts/attacks/" + attack_name + ".txt", FileAccess.READ).get_as_text().strip_edges().split("[Pattern]")
	atk_data = atk_metadata[1].strip_edges().split("\n")
	curr_atk_data = atk_data[0].strip_edges().split(",")
	atk_metadata = atk_metadata[0].strip_edges().split(",")
	atk_total_duration = float(atk_metadata[2])

# Returns true if the next bullet is ready to be spawned
func next_bullet_ready():
	if curr_atk_data.size() == 0:
		return false
	if atk_time >= float(curr_atk_data[0]):
		return true
	return false

# Returns the next bullet position based on the current attack data index
func next_bullet_position(bullet_global_position: Vector2, bullet_rotation: float):
	if next_atk_data_index > atk_data.size():
		return Vector2(0, 0)

	# Checks if bullet is relative or absolute position, and convert to global position if relative (0 is relative)
	if curr_atk_data[1] == "0":
		return bullet_global_position + Vector2(float(curr_atk_data[2]), float(curr_atk_data[3])).rotated(bullet_rotation)
	if curr_atk_data[1] == "2":
		# (bullet_rotation)
		# print(player_character.global_position + Vector2(float(curr_atk_data[2]), float(curr_atk_data[3])).rotated(bullet_rotation))
		return player_character.global_position + Vector2(float(curr_atk_data[2]), float(curr_atk_data[3])).rotated(bullet_rotation)
	return Vector2(float(curr_atk_data[2]), float(curr_atk_data[3]))

# Makes and returns a bullet object
func get_bullet(bullet_global_position: Vector2, bullet_rotation_offset: float = 0.0, bullet_velocity_multiplier: float = 1.0):
	var bullet = load("res://scenes/entities/bullets/" + curr_atk_data[9] + ".tscn").instantiate()
	bullet.global_position = next_bullet_position(bullet_global_position, deg_to_rad(fmod(bullet_rotation_offset*float(atk_metadata[1]), 360)))
	bullet.rotation = deg_to_rad(float(curr_atk_data[4]) + fmod(bullet_rotation_offset*float(atk_metadata[1]), 360))
	bullet.velocity = Vector2(float(curr_atk_data[5]) * bullet_velocity_multiplier, 0).rotated(bullet.rotation)
	bullet.acceleration = float(curr_atk_data[6])
	bullet.damage = float(curr_atk_data[7])
	bullet.lifetime = float(curr_atk_data[8])
	atk_time = 0.0
	return bullet

# Loads the next bullet data
func next_bullet():
	if next_atk_data_index >= atk_data.size():
		curr_atk_data = []
		return
	curr_atk_data = atk_data[next_atk_data_index].strip_edges().split(",")
	next_atk_data_index += 1

# Updates the attack time
func update_attack_time(delta):
	atk_time += delta

# Check if attack is finished
func attack_finished():
	if curr_atk_data.size() == 0 and atk_time >= atk_total_duration:
		return true
	return false
