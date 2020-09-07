class_name ElementaryEvent

var score=0
var experience=0
var card=0
var hero=0
var antihero=0
var corruption=0

func _init():
	score=0
	experience=0
	card=0
	hero=0
	antihero=0
	corruption=0

func add_side(side:int):
	match side:
		RuneSides.one:
			add_one()
		RuneSides.two:
			add_two()
		RuneSides.corruption:
			add_corruption()
		RuneSides.card:
			add_card()
		RuneSides.experience:
			add_experience()
		RuneSides.hero:
			add_hero()
		RuneSides.antihero:
			add_antihero()
		_:
			pass
	
func add_one():
	score += 1

func add_two():
	score += 2

func add_experience():
	experience += 1

func add_card():
	card += 1

func add_hero():
	hero += 1

func add_antihero():
	antihero += 1

func add_corruption():
	corruption += 1
	score += 2

func display():
	print("{\nscore : "+str(score))
	print("experience : "+str(experience))
	print("card : "+str(card))
	print("hero : "+str(hero))
	print("antihero : "+str(antihero))
	print("corruption : "+str(corruption)+"\n}\n")
