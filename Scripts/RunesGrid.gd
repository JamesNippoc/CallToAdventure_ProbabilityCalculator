extends GridContainer

signal runes_changed
signal expectation_update

const name2enum = {
	"Basic":RuneGroups.basic, "Dark":RuneGroups.dark,
	"Strength":RuneGroups.strength, "Dexterity":RuneGroups.dexterity,
	"Constitution":RuneGroups.constitution, "Intelligence":RuneGroups.intelligence,
	"Wisdom":RuneGroups.wisdom, "Charisma":RuneGroups.charisma}

func _ready():
	$TextureButton.connect("button_down", self, "reset_selection")
	for runes_group in get_tree().get_nodes_in_group("RunesGroup"):
		runes_group.connect("rune_button_down", self, "on_rune_button_down")
	update_values()

func reset_selection():
	for runes_group in get_tree().get_nodes_in_group("RunesGroup"):
		runes_group.reset_selection()
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
	emit_signal("expectation_update", Probas.GetExpectation())
	emit_signal("runes_changed")

func on_rune_button_down(runes_group:RunesGroup, rune_index:int):
	var selection = runes_group.get_n_selected_runes()
	if selection==0 and runes_group.name!="Dark" and get_n_selected_ability_group()>=2:
		return
	runes_group.handle_selection(selection, rune_index)
	update_values()

func get_n_selected_runes(group:String)->int:
	for runes_group in get_tree().get_nodes_in_group("RunesGroup"):
		if runes_group.name==group:
			return runes_group.get_n_selected_runes()
	return 0

func get_n_selected_ability_group()->int:
	var n = 0
	for runes_group in get_tree().get_nodes_in_group("RunesGroup"):
		if runes_group.name!="Dark" and (runes_group as RunesGroup).get_n_selected_runes()>0:
			n+=1
	return n

func save_selected_runes():
	Values.selected_runes.clear()
	for runes_group in get_tree().get_nodes_in_group("RunesGroup"):
		var n_selected = runes_group.get_n_selected_runes()
		if n_selected!=0:
			Values.selected_runes[runes_group.name]=runes_group.get_n_selected_runes()

func load_selected_runes():
	for runes_group in get_tree().get_nodes_in_group("RunesGroup"):
		if Values.selected_runes.has(runes_group.name):
			runes_group.handle_selection(0, Values.selected_runes[runes_group.name])
	update_values()
