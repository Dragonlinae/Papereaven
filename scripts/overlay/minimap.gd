extends Node2D

var camera : Camera2D = null
var subview : SubViewport = null
var charcontroller : CharacterController = null

# Called when the node enters the scene tree for the first time.
func _ready():
	subview = get_node("SubViewport")
	camera = get_node("SubViewport/Camera2D")
	subview.world_2d = get_tree().get_root().get_viewport().get_world_2d()
	charcontroller = get_tree().get_root().get_node("Node2D/Player")
	var remote_transform := RemoteTransform2D.new()
	remote_transform.name = "RemoteTransformMinimap"
	remote_transform.remote_path = camera.get_path()
	charcontroller.call_deferred("add_child", remote_transform)
