extends ColorRect

onready var HUD = get_node("/root/Game/HUD")
var c = 0
var colors = [
	Color8(95,61,196)		#gray 9
	,Color8(103,65,217)		#gray 8
	,Color8(112,72,232)		#gray 7
	,Color8(121,80,242)

]


func _ready():
	update_color()


func update_color():
	$Tween.interpolate_property(self, "color", color, colors[c], $Timer.wait_time-0.01, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_Timer_timeout():
	c += 1
	c %= colors.size()
	update_color()
