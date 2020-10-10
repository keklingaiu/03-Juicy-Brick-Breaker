extends KinematicBody2D

onready var target_y = position.y

var row = 0
var col = 0


export var appear_speed = 3
export var fall_speed = 1.0

var dying = false

var colors = [
	Color8(43,138,62)	
	,Color8(47,158,68)
	,Color8(55,178,77)	
	,Color8(12,166,120)
	,Color8(18,184,134)	
	,Color8(56,217,169)	
	,Color8(59,201,219)	
	,Color8(102,217,232)
	,Color8(153,233,242)
]
onready var textures = [
	load("res://Assets/flash00.png")
	,load("res://Assets/flash01.png")
	,load("res://Assets/flash02.png")
	,load("res://Assets/flash03.png")
]

func _ready():
	randomize()
	update_color()

func _process(_delta):
	if dying and not $Particles2D.emitting and not $Tween.is_active() and not $Color_Tween.is_active():
		queue_free()


func start_brick():
	var target_pos = position
	var appear_duration = randf()*appear_speed + 1.0
	position.y = -100
	$Tween.interpolate_property(self, "position", position, target_pos, appear_duration, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	$Tween.start()


func update_color():
	if row >= 0 and row < colors.size():
		$Color.color = colors[row]

func emit_particle(pos):
	$Particles2D.texture = textures[randi() % textures.size()]
	$Particles2D.emitting = true
	$Particles2D.global_position = pos
	

func die():
	dying = true
	var target_color = $Color.color.darkened(0.75)
	target_color.a = 0
	var fall_duration = randf()*fall_speed + 1
	var target_pos = position
	target_pos.y = 1000
	$Tween.interpolate_property(self, "position", position, target_pos, fall_duration, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.start()

	$Tween.interpolate_property($Color, "color", $Color.color, target_color, fall_duration-0.25, Tween.TRANS_EXPO, Tween.EASE_IN)
	$Tween.start()

	$Color.color = target_color
	Global.update_score(200)


	collision_layer = 0
	collision_mask = 0
