extends Node

var landscape_scene = preload("res://Scenes/Landscape.tscn")
var portrait_scene = preload("res://Scenes/Portrait.tscn")
var reverse_landscape_scene = preload("res://Scenes/ReverseLandscape.tscn")

enum Orientation{
	LANDSCAPE,
	PORTRAIT,
	REVERSE_LANDSCAPE,
}

var current_scene
var orientation = Orientation.PORTRAIT

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func _process(delta):
	var new_orientation = gravity2orientation(Input.get_gravity())
	if orientation!=new_orientation:
		change_orientation(new_orientation)
	orientation = new_orientation

func gravity2orientation(gravity3D:Vector3)->int:
	var angle = norm_angle_from(Vector2(gravity3D.x, gravity3D.y).angle(), -5*PI/6)
	if angle<-PI/6:
		return Orientation.PORTRAIT
	if angle<PI/2: return Orientation.REVERSE_LANDSCAPE
	return Orientation.LANDSCAPE

func norm_angle_from(angle:float, from:float)->float:
	while angle<=from:
		angle+=2*PI
	while angle>from+2*PI:
		angle-=2*PI
	return angle

func change_orientation(new_orientation:int):
	match new_orientation:
		Orientation.PORTRAIT:
			deferred_goto_scene(portrait_scene)
		Orientation.LANDSCAPE:
			deferred_goto_scene(landscape_scene)
		Orientation.REVERSE_LANDSCAPE:
			deferred_goto_scene(reverse_landscape_scene)

func deferred_goto_scene(scene:PackedScene):
	current_scene.save_values()
	current_scene.free()
	current_scene = scene.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
