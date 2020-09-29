extends HSlider

signal difficulty_value_changed

func _ready():
	connect("value_changed", self, "on_value_changed")

func on_value_changed(value):
	emit_signal("difficulty_value_changed", value)

func get_value()->float:
	return value

func set_value(new_value:float):
	value = new_value
