extends Control

func _ready():
	Global.connect("changed", self, "_on_Global_changed")
	update_lives()
	update_score()
	
func update_score():
	$Score.text = "Score: " + str(Global.score)

func update_lives():
	$Lives.text = "Lives: " + str(Global.lives)

func _on_Global_changed():
	update_score()
	update_lives()
