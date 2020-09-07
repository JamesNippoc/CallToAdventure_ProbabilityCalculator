extends Node

var elementary_events = []
var inverse_cdf = []
var expectation = 0.0

var runes = {
	Runes.basic:[RuneSides.one, RuneSides.zero],
	Runes.basic_card:[RuneSides.one, RuneSides.card],
	Runes.ability:[RuneSides.two, RuneSides.one],
	Runes.ability_experience:[RuneSides.two, RuneSides.experience],
	Runes.ability_hero:[RuneSides.two, RuneSides.hero],
	Runes.ability_antihero:[RuneSides.two, RuneSides.antihero],
	Runes.dark:[RuneSides.corruption, RuneSides.one],
}

func GetProbaGreaterOrEqual(score:int)->float:
	if score<=0: return 1.0
	if score > inverse_cdf.size(): return 0.0
	return inverse_cdf[score-1]

func GetExpectation()->float:
	return expectation

func CastRunes(runes_dictionary:Dictionary):
	var runes_list = []
	for rune in runes_dictionary.keys():
		for i in runes_dictionary[rune]:
			runes_list.append(rune)
	CastRunesArray(runes_list)

func CastRunesArray(runes_list:Array):
	elementary_events.clear()
	elementary_events.append(ElementaryEvent.new())
	for rune in runes_list:
		var new_events = []
		for side in runes[rune]:
			var side_events = duplicate_events()
			for event in side_events:
				if event.has_method("add_side"):
					event.add_side(side)
			new_events = new_events + side_events
		elementary_events = new_events
	compute_inverse_cdf()
	compute_expectation()

func duplicate_events()->Array:
	var d = []
	for event in elementary_events:
		d.append(duplicate_event(event))
	return d

func duplicate_event(event:ElementaryEvent)->ElementaryEvent:
	var e = ElementaryEvent.new()
	e.score = event.score
	e.experience = event.experience
	e.card = event.card
	e.hero = event.hero
	e.antihero = event.antihero
	e.corruption = event.corruption
	return e

func compute_inverse_cdf():
	inverse_cdf.clear()
	var size = elementary_events.size()
	var n = elementary_events.size()
	var score = 1
	while true:
		for event in elementary_events:
			if event.score==score-1:
				n -= 1
		if n<=0:
			return
		inverse_cdf.append(float(n)/float(size))
		score += 1

func compute_expectation():
	var sum = 0
	for event in elementary_events:
		sum += event.score
	expectation = float(sum)/float(elementary_events.size())
