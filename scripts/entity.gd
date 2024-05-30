extends CharacterBody2D
class_name Entity

## Maximum health (what health gets restored to)
@export var max_health: int = 10

## Current health (also initial health when set)
@export var current_health: int = 10

## Should the tree be removed when health <= 0
@export var destroy_when_dead: bool = true

var hittable: bool = true

signal damage_taken(damage_amount)

# Hit indicators
var hit_counter: int = 0
const hit_color := Color(1, 0, 0)
const default_color := Color(1, 1, 1)

# Music to unload when dead
var audio_stream_player: AudioStreamPlayer = null

## Damage modifier (used in block & parry)
var damage_factor: float = 1.0

func restore_health():
	current_health = max_health

## Damage taken will have damage reduction applied.
## This method scales the damage before applying.
func take_damage(damage: int):
	force_full_damage(int(damage * damage_factor))

## Damage will not have damage reduction applied.
## This method does the actual damaging and post-damage events.
## `take_damage` will scale damage before passing it though.
func force_full_damage(damage: int):
	if not hittable: return
	if damage <= 0: return # don't start the flicker behavior
	damage_taken.emit(damage)
	current_health -= damage
	if is_dead() and destroy_when_dead:
		if audio_stream_player != null:
			audio_stream_player.stop()
			audio_stream_player.queue_free()
		queue_free()
	else: # Wrap this into a function? Also, do all entities have the same knockup? Are some enemies immune to knockup?
		set_velocity(Vector2(0, -400))
		# flicker
		hit_counter += 1
		var curr_hit_counter = hit_counter
		var flicker_frames = 6
		while flicker_frames != 0 and curr_hit_counter == hit_counter:
			set_modulate(default_color if flicker_frames&1 else hit_color)
			flicker_frames -= 1
			await get_tree().create_timer(2 / 60.0).timeout

func is_dead():
	return current_health <= 0

func is_alive():
	return current_health > 0

func set_damage_factor(new_damage_factor: float):
	# print("Set new damage factor to", new_damage_factor)
	damage_factor = new_damage_factor

func set_hittable(new_hittable: bool):
	hittable = new_hittable

## This music will be cut short when the entity dies.
func set_audio_stream_player(new_audio_stream_player: AudioStreamPlayer):
	audio_stream_player = new_audio_stream_player
