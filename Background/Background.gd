extends ColorRect

var c = 0
var colors = [
	Color8(33,37,41)	
	,Color8(52,58,64)
	,Color8(73,80,87)	
	,Color8(134,142,150)	
	
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
