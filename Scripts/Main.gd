extends Control

onready var runes_container = find_node("RunesGrid")
onready var difficulty_text = find_node("Difficulty")
onready var probability_text = find_node("Probability")
onready var expectation_text = find_node("Expectation")
onready var difficulty_slider = find_node("DifficultySlider")

func _ready():
	add_to_group("Main")
	runes_container.connect("expectation_update", self, "on_expectation_updated")
	runes_container.connect("runes_changed", self, "update_probability")
	difficulty_slider.connect("difficulty_value_changed", self, "on_difficulty_changed")
	load_values()
	
	if OS.is_debug_build():
		test()

func test():
	pass

func on_expectation_updated(expe:float):
	expectation_text.text = str(expe)

func update_probability():
	probability_text.text = str(round(Probas.GetProbaGreaterOrEqual(difficulty_slider.get_value()) * 100))+" %"

func on_difficulty_changed(value):
	difficulty_text.text = str(value)
	update_probability()

func save_values():
	runes_container.save_selected_runes()
	Values.difficulty = difficulty_slider.get_value()

func load_values():
	runes_container.load_selected_runes()
	difficulty_slider.set_value(Values.difficulty)
