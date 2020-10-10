extends RigidBody2D

export var max_speed = 400.0
export var min_speed = 100.0
onready var camera = get_node("/root/Game/Camera")

onready var effect_paddle = get_node("/root/Game/Effect_Paddle")
onready var effect_wall = get_node("/root/Game/Effect_Wall")
onready var effect_brick = get_node("/root/Game/Effect_Brick")

onready var VP = get_viewport_rect().size

var wall_trauma = 0.005
var paddle_trauma = 0.008
var brick_trauma = 0.01

func _ready():
	contact_monitor = true
	set_max_contacts_reported(4)
	position = Vector2(VP.x/2, VP.y - 200)
	update_color()


func update_color():
	$Color.color = Color8(81,207,102)
	$Particles2D.emitting = true

func screen_shake(amount):
	camera.add_trauma(amount*75.0)

func play_sound(sound):
	sound.play()


func _physics_process(_delta):
	
	if position.y > VP.y + 30:
		die()
	
	var c = $Color.duplicate()
	c.rect_global_position = global_position
	c.color = c.color.darkened(0.4)
	get_node("/root/Game/Trail_Container").add_child(c)


	var bodies = get_colliding_bodies()
	for body in bodies:
		if body.name == "Walls":
			screen_shake(wall_trauma)
			play_sound(effect_wall)
		if body.name == "Paddle":
			screen_shake(paddle_trauma)
			play_sound(effect_paddle)
		if body.is_in_group("Brick"):
			screen_shake(brick_trauma)
			play_sound(effect_brick)
			
		if body.has_method("emit_particle"):
			body.emit_particle(global_position)
		if body.is_in_group("Brick"):
			body.die()

func _integrate_forces(state):
	if abs(state.linear_velocity.x) < min_speed:
		state.linear_velocity.x = sign(state.linear_velocity.x) * min_speed
	if abs(state.linear_velocity.y) < min_speed:
		state.linear_velocity.y = sign(state.linear_velocity.y) * min_speed
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed
		
		
func die():
	Global.update_lives(-1)
	queue_free()
