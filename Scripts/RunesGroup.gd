extends TextureRect

class_name RunesGroup

signal rune_button_down

const opacity = 200

func _ready():
	add_to_group("RunesGroup")
	reset_selection()
	for j in range(3):
		var rune = find_node("Button"+str(j+1)) as Button
		rune.connect("button_down", self, "on_rune_button_down", [j+1])

func on_rune_button_down(index:int):
	emit_signal("rune_button_down", self, index)

func get_n_selected_runes()->int:
	var selection = 3
	for i in range(3):
		if (find_node("Polygon"+str(i)) as Polygon2D).visible:
			selection = i
			break
	return selection

func handle_selection(n_selected:int, rune_index:int):
	# deselect from rune_index
	if n_selected>=rune_index:
		if n_selected != 3:
			(find_node("Polygon"+str(n_selected)) as Polygon2D).visible = false
		(find_node("Polygon"+str(rune_index-1)) as Polygon2D).visible = true
	# select all up to rune_index
	else:
		(find_node("Polygon"+str(n_selected)) as Polygon2D).visible = false
		if rune_index!=3:
			(find_node("Polygon"+str(rune_index)) as Polygon2D).visible = true

func reset_selection():
	for j in range(3):
		var polygon = find_node("Polygon"+str(j)) as Polygon2D
		polygon.color.a8 = opacity
		polygon.visible = j==0
