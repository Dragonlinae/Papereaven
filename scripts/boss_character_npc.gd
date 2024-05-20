extends Area2D

@export var player_character : CharacterBody2D
var dialogue_box_scene = preload("res://scenes/overlay/dialogue_box.tscn")
var dialogue_box = null
var dialogues : Array[String] = ["You... dodged that?", "I'm impressed.", "But you're not getting away that easily!"]
var activated = false

func _ready():
	area_exited.connect(Callable(self, "_on_area_exited"))

func _process(delta):
	if activated:
		activated = false
		dialogue_box = get_node("Dialogue")
		var audio : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		audio.stream = load("res://assets/audio/leva-in-the-dark-176514.mp3")
		get_parent().add_child(audio)
		audio.play()
		for particle in get_node("AttackFX").get_children():
			particle.emitting = true
		await get_tree().create_timer(3).timeout
		dialogue_box.next_dialogue()
		await get_tree().create_timer(3).timeout
		dialogue_box.next_dialogue()
		await get_tree().create_timer(3).timeout
		dialogue_box.next_dialogue()
		await get_tree().create_timer(3).timeout
		var boss : CharacterBody2D = load("res://scenes/entities/boss.tscn").instantiate()
		boss.player_character = player_character
		boss.global_position = global_position
		get_parent().add_child(boss)
		queue_free()

func _on_area_exited(area):
	if get_node("Dialoguearea").spoken:
		get_node("Dialoguearea").queue_free()
		get_node("CollisionShape2D2").queue_free()
		dialogue_box = dialogue_box_scene.instantiate()
		dialogue_box.dialogues = dialogues
		add_child(dialogue_box)
		activated = true
