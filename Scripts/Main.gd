extends Control

onready var runes_container = $HBoxContainer/ColorRect/GridContainer
onready var difficulty_text = find_node("Difficulty")
onready var probability_text = find_node("Probability")
onready var expectation_text = find_node("Expectation")
onready var difficulty_slider = find_node("DifficultySlider")


const opacity = 200
var name2enum = {
	"Basic":RuneGroups.basic, "Dark":RuneGroups.dark,
	"Strength":RuneGroups.strength, "Dexterity":RuneGroups.dexterity,
	"Constitution":RuneGroups.constitution, "Intelligence":RuneGroups.intelligence,
	"Wisdom":RuneGroups.wisdom, "Charisma":RuneGroups.charisma}

# Called when the node enters the scene tree for the first time.
func _ready():
	runes_container.get_child(0).connect("button_down", self, "reset_selection")
	reset_selection(true)
	difficulty_slider.connect("value_changed", self, "on_difficulty_changed")
	
	if OS.is_debug_build():
		test()

func test():
	pass

func reset_selection(connect:bool=false):
	for i in range(2, runes_container.get_child_count()):
		var runes_group = runes_container.get_child(i)
		for j in range(3):
			var polygon = runes_group.find_node("Polygon"+str(j)) as Polygon2D
			polygon.color.a8 = opacity
			polygon.visible = j==0
			var rune = runes_group.find_node("Button"+str(j+1)) as Button
			if connect:
				rune.connect("button_down", self, "on_rune_button_down", [runes_group.name, j+1])
	update_values()

func update_values():
	var n_ability_runes=0
	var n_experience_runes=0
	var n_hero_runes=0
	var n_antihero_runes=0
	for rune_group in name2enum.keys():
		if rune_group != "Basic" and rune_group != "Dark":
			var n = get_n_selected_runes(rune_group)
			if n==3:
				match rune_group:
					"Strength","Constitution":
						n_experience_runes+=1
					"Intelligence","Wisdom":
						n_hero_runes+=1
					"Dexterity","Charisma":
						n_antihero_runes+=1
				n=2
			n_ability_runes+=n
	Probas.CastRunes(
		{Runes.basic:2, Runes.basic_card:1, Runes.dark:get_n_selected_runes("Dark"),
		Runes.ability:n_ability_runes, Runes.ability_experience:n_experience_runes,
		Runes.ability_hero:n_hero_runes, Runes.ability_antihero:n_antihero_runes})
	expectation_text.text = str(Probas.GetExpectation())
	update_probability()

func update_probability():
	probability_text.text = str(round(Probas.GetProbaGreaterOrEqual(difficulty_slider.value) * 100))+" %"

func on_difficulty_changed(value):
	difficulty_text.text = str(value)
	update_probability()

func on_rune_button_down(rune_group:String, rune_index:int):
	var selection = get_n_selected_runes(rune_group)
	if selection==0 and rune_group!="Dark" and get_n_selected_ability_group()>=2:
		return
	# deselect from rune_index
	if selection>=rune_index:
		if selection != 3:
			(runes_container.find_node(rune_group).find_node("Polygon"+str(selection)) as Polygon2D).visible = false
		(runes_container.find_node(rune_group).find_node("Polygon"+str(rune_index-1)) as Polygon2D).visible = true
	# select all up to rune_index
	else:
		(runes_container.find_node(rune_group).find_node("Polygon"+str(selection)) as Polygon2D).visible = false
		if rune_index!=3:
			(runes_container.find_node(rune_group).find_node("Polygon"+str(rune_index)) as Polygon2D).visible = true
	update_values()

func get_n_selected_runes(rune_group:String)->int:
	var selection = 3
	for i in range(3):
		if (runes_container.find_node(rune_group).find_node("Polygon"+str(i)) as Polygon2D).visible:
			selection = i
			break
	return selection

func get_n_selected_ability_group()->int:
	var n = 0
	for i in range(3, runes_container.get_child_count()):
		var rune_group = runes_container.get_child(i).name
		if get_n_selected_runes(rune_group)>0:
			n+=1
	return n
