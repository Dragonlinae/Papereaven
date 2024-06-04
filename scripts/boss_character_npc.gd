extends Area2D

@export var player_character: CharacterBody2D
@export_file var dialogue_file: String = ""
@export var boss_health: int = 10000

var dialogue_box_scene = preload ("res://scenes/overlay/dialogue_box.tscn")
var dialogue_box = null
var dialogues: PackedStringArray
var activated = false

func _ready():
	if dialogue_file != "":
		var file = FileAccess.open(dialogue_file, FileAccess.READ)
		dialogues = file.get_as_text().strip_edges().split("\n")
		file.close()
	area_exited.connect(Callable(self, "_on_area_exited"))

func _process(delta):
	if activated:
		activated = false
		dialogue_box = get_node("Dialogue")
		var audio: AudioStreamPlayer = AudioStreamPlayer.new()
		audio.stream = load("res://assets/audio/leva-in-the-dark-176514.mp3")
		get_parent().add_child(audio)
		audio.play()
		if dialogue_file != "":
			for particle in get_node("AttackFX").get_children():
				particle.emitting = true
			await get_tree().create_timer(3).timeout
			dialogue_box.next_dialogue()
			await get_tree().create_timer(3).timeout
			dialogue_box.next_dialogue()
			await get_tree().create_timer(3).timeout
			dialogue_box.next_dialogue()
			await get_tree().create_timer(3).timeout
		var boss: Entity = load("res://scenes/entities/boss.tscn").instantiate()
		boss.player_character = player_character
		boss.global_position = global_position
		boss.max_health = boss_health
		boss.current_health = boss_health
		boss.set_audio_stream_player(audio)
		get_parent().add_child(boss)
		queue_free()

func _on_area_exited(area):
	var dialogue_area: DialogueArea2D = get_node("Dialoguearea")
	if dialogue_area != null and dialogue_area.spoken:
		get_node("Dialoguearea").queue_free()
		get_node("CollisionShape2D2").queue_free()
		dialogue_box = dialogue_box_scene.instantiate()
		if dialogue_file != "":
			dialogue_box.dialogues = dialogues
			add_child(dialogue_box)
		activated = true
