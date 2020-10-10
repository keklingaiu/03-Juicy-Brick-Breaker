extends KinematicBody2D

onready var target_y = position.y

var row = 0
var col = 0


export var appear_speed = 3
export var fall_speed = 1.0

var dying = false

var colors = [
	Color8(201,42,42)	
	,Color8(250,82,82)	
	,Color8(253,126,20)	
	,Color8(255,169,77)	
	,Color8(252,196,25)	
	,Color8(255,224,102)
	,Color8(255,243,191)
	,Color8(255,224,102)
	,Color8(255,243,191)
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
	Global.update_score(100)


	collision_layer = 0
	collision_mask = 0
