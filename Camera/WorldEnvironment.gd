extends WorldEnvironment


func _ready():
	show()

func show():
	environment.background_mode = Environment.BG_CANVAS

func hide():
	environment.background_mode = Environment.BG_CLEAR_COLOR

