extends ColorRect

var c = 0
var colors = [
	Color8(95,61,196)			#black
	,Color8(112,72,232)		#gray 9
	,Color8(132,94,247)		#gray 8
	,Color8(177,151,252)		#gray 9
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
